codeunit 60111 "Email Mgt"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Document-Print", OnBeforeDoPrintSalesHeader, '', false, false)]
    procedure OnBeforeDoPrintSalesHeader(
        var SalesHeader: Record "Sales Header";
        ReportUsage: Integer;
        SendAsEmail: Boolean;
        var IsPrinted: Boolean)
    var
        ReportSelections: Record "Report Selections";
    begin
        if not SendAsEmail then
            exit;

        if SalesHeader."Document Type" <> SalesHeader."Document Type"::Order then
            exit;

        ReportSelections.SendEmailToCust(ReportSelections.Usage::"S.Order", SalesHeader, SalesHeader."No.", 'Sales Order', true, SalesHeader."Sell-to Customer No.");

        IsPrinted := true;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Document-Mailing", 'OnBeforeEmailFileInternal', '', false, false)]
    local procedure OnBeforeEmailFileInternalHandler(
    var TempEmailItem: Record "Email Item" temporary;
    var HtmlBodyFilePath: Text[250];
    var EmailSubject: Text[250];
    var ToEmailAddress: Text[250];
    PostedDocNo: Code[20];
    var EmailDocName: Text[250];
    HideDialog: Boolean;
    ReportUsage: Integer;
    IsFromPostedDoc: Boolean;
    SenderUserID: Code[50];
    EmailScenario: Enum "Email Scenario";
    var EmailSentSuccessfully: Boolean;
    var IsHandled: Boolean)
    var
        ReportUsageEnum: Enum "Report Selection Usage";
    begin
        if ReportUsage = ReportUsageEnum::"S.Order".AsInteger() then begin
            EmailDocName := 'Sales Order Confirmation';
        end;
    end;
}