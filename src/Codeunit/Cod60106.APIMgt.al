codeunit 60106 "API Mgt."
{
    procedure PendingRequest()
    var
        Client: HttpClient;
        Request: HttpRequestMessage;
        Response: HttpResponseMessage;
        JsonText: Text;
        JsonArray: JsonArray;
        JsonToken: JsonToken;
        JsonObj: JsonObject;
        PendingRequestRec: Record "Pending Request" temporary;
        Headers: HttpHeaders;
        Content: HttpContent;
        AccessToken: Text;
    begin
        AccessToken := GetAccessToken();

        Request.GetHeaders(Headers);
        Headers.Add('Authorization', StrSubstNo('Bearer %1', AccessToken));
        Request.SetRequestUri('https://api-services.uat.1placedessaisons.com/uatm/riskinfo/v3/coverRequests/search');
        Request.Method := 'POST';

        Content.WriteFrom(
            '{' +
            '"policies": [' +
                '{' +
                    '"businessUnitCode": "EHDK",' +
                    '"policyId": "034421"' +
                '},' +
                '{' +
                    '"businessUnitCode": "EHDK",' +
                    '"policyId": "034553",' +
                    '"extensionId": "DCL"' +
                '},' +
                '{' +
                    '"businessUnitCode": "EHDK",' +
                    '"policyId": "034635",' +
                    '"extensionId": "CAP"' +
                '}' +
            '],' +
            '"requestStatusCode": "InProgress",' +
            '"pagination": {' +
                '"page": 1,' +
                '"pageSize": 5000,' +
                '"isTotalRequired": "true"' +
            '}' +
            '}'
        );

        Content.GetHeaders(Headers);
        Headers.Clear();
        Headers.Remove('Content-Type');
        Headers.Add('Content-Type', 'application/json');
        Request.Content := Content;

        if Client.Send(Request, Response) then begin
            if Response.IsSuccessStatusCode() then begin
                Response.Content().ReadAs(JsonText);
                JsonArray.ReadFrom(JsonText);

                foreach JsonToken in JsonArray do begin
                    JsonObj := JsonToken.AsObject();

                    PendingRequestRec.Init();
                    JsonObj.Get('requestId', JsonToken);
                    PendingRequestRec."Request ID" := JsonToken.AsValue().AsText();
                    JsonObj.SelectToken('creditLimitDetails.requestedAmount', JsonToken);
                    PendingRequestRec."Requested Amount" := JsonToken.AsValue().AsDecimal();
                    JsonObj.SelectToken('creditLimitDetails.currencyCode', JsonToken);
                    PendingRequestRec.Currency := JsonToken.AsValue().AsText();
                    JsonObj.Get('creationDate', JsonToken);
                    PendingRequestRec."Requested Date" := JsonToken.AsValue().AsDate();
                    JsonObj.Get('lastUpdateDate', JsonToken);
                    PendingRequestRec."Last Update Date" := JsonToken.AsValue().AsDate();
                    JsonObj.Get('coverId', JsonToken);
                    PendingRequestRec.CoverID := JsonToken.AsValue().AsText();
                    PendingRequestRec.Insert();
                end;

                PAGE.RunModal(PAGE::"Pending Request List", PendingRequestRec);
            end else
                Message('API call failed: %1', Response.HttpStatusCode());
        end else
            Error('Unable to send request');
    end;

    local procedure GetAccessToken(): Text
    var
        Client: HttpClient;
        Request: HttpRequestMessage;
        Response: HttpResponseMessage;
        Content: HttpContent;
        Headers: HttpHeaders;
        JsonBody: Text;
        JsonResponse: Text;
        JsonObj: JsonObject;
        AccessToken: Text;
        Token: JsonToken;
    begin
        JsonBody := '{"apiKey":"cmFqZW5AYWVnaXNzb2Z0dGVjaC5jb206SEB2djI4Ri8ibmpAZzhiQnVOY0kzPTl2dlI9Ln1N"}';

        Request.SetRequestUri('https://api-services.uat.1placedessaisons.com/uatm/v1/idp/oauth2/authorize');
        Request.Method := 'POST';

        Content.WriteFrom(JsonBody);

        Content.GetHeaders(Headers);
        Headers.Clear();
        Headers.Remove('Content-Type');
        Headers.Add('Content-Type', 'application/json');
        Request.Content := Content;

        if Client.Send(Request, Response) then begin
            if Response.IsSuccessStatusCode() then begin
                Response.Content().ReadAs(JsonResponse);
                JsonObj.ReadFrom(JsonResponse);
                if JsonObj.Get('access_token', Token) then
                    exit(Token.AsValue().AsText())
                else
                    Error('Access token not found in response');
            end else
                Error('Token request failed: %1', Response.HttpStatusCode());
        end else
            Error('Unable to send token request');
    end;
}