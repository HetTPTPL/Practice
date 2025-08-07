pageextension 60100 "Item Card Ext" extends "Item Card"
{

    layout
    {
        modify("Manufacturer Code")
        {
            ApplicationArea = all;
            Visible = true;
            Importance = Standard;
        }

        addafter("Description 2")
        {
            field("Description 4"; Rec."Description 4")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Description 4 field.', Comment = '%';
            }
        }
    }

    actions
    {
        addlast(Availability)
        {
            action("Show Credit Lines")
            {
                ApplicationArea = all;
                Caption = 'Show Credit Lines';
                ToolTip = 'Show Credit Lines';
                Image = Line;
                trigger OnAction()
                var
                    ItemMgt: Codeunit "Item Card Mgt.";
                begin
                    ItemMgt.ShowCreditMemoLine(Rec);
                end;
            }
        }
        addlast(Promoted)
        {
            actionref(ShowCreditLines_Promoted; "Show Credit Lines")
            {
            }
        }
        addfirst(processing)
        {
            group(QR)
            {
                action(GenerateQRCode)
                {
                    ApplicationArea = All;
                    Caption = 'Generate QR Code';
                    Image = CreateDocument;

                    trigger OnAction()
                    var
                        BarcodeAPIURL: Text;
                        Client: HttpClient;
                        HttpResponseMsg: HttpResponseMessage;
                        HttpRequestMsg: HttpRequestMessage;
                        InS: InStream;
                        OverrideImageQst: Label 'The existing picture will be replaced. Do you want to continue?';
                        MustSpecifyDescriptionErr: Label 'You must add a description to the item before you can import a picture.';
                        FileName: Text;
                        BarcodeTypes: Label 'QR Code, Data Matrix, Aztec, Telepen, Swiss QR Code';
                        Selection: Integer;
                    begin
                        if Rec.Description = '' then
                            Error(MustSpecifyDescriptionErr);
                        if Rec.Picture.Count > 0 then
                            if not Confirm(OverrideImageQst) then
                                Error('');
                        FileName := Rec.Description + '.png';
                        // BarcodeAPIURL := 'https://quickchart.io/qr?text=' + Rec."No." + '_' + Rec.Description;
                        BarcodeAPIURL := 'https://quickchart.io/barcode?type=' + 'qrcode' + '&text=' + Rec."No." + '_' + Rec.Description + '&width=200&height=200&format=png';

                        // Selection := StrMenu(BarcodeTypes);
                        // case
                        //     Selection of
                        //     1:
                        //         BarcodeAPIURL := 'https://quickchart.io/barcode?type=' + 'qrcode' + '&text=' + Rec."No." + '_' + Rec.Description + '&width=200&height=200&format=png';
                        //     2:
                        //         BarcodeAPIURL := 'https://quickchart.io/barcode?type=' + 'datamatrix' + '&text=' + Rec."No." + '_' + Rec.Description + '&width=200&height=200&format=png';
                        //     3:
                        //         BarcodeAPIURL := 'https://quickchart.io/barcode?type=' + 'azteccode' + '&text=' + Rec."No." + '_' + Rec.Description + '&width=200&height=200&format=png';
                        //     4:
                        //         BarcodeAPIURL := 'https://quickchart.io/barcode?type=' + 'telepen' + '&text=' + Rec."No." + '_' + Rec.Description + '&width=200&height=200&format=png';
                        //     5:
                        //         BarcodeAPIURL := 'https://quickchart.io/barcode?type=' + 'swissqrcode' + '&text=' + Rec."No." + '_' + Rec.Description + '&width=200&height=200&format=png';
                        // end;

                        HttpRequestMsg.SetRequestUri(BarcodeAPIURL);
                        if Client.Send(HttpRequestMsg, HttpResponseMsg) then begin
                            if HttpResponseMsg.IsSuccessStatusCode() then begin
                                Message('%1', HttpResponseMsg.HttpStatusCode);
                                HttpResponseMsg.Content.ReadAs(InS);
                                Clear(Rec.Picture);
                                Rec.Picture.ImportStream(InS, FileName);
                                Rec.Modify(true);
                            end;
                        end else
                            Error('Failed to send request to the API.');
                    end;
                }
                action(GenerateQRImage)
                {
                    ApplicationArea = all;
                    Caption = 'Generate QR Image';
                    Image = AddContacts;

                    trigger OnAction()
                    var
                        SwissQRCodeHelper: Codeunit "Swiss QR Code Helper";
                        TempBlob: Codeunit "Temp Blob";
                        SourceText: Text;
                        FileName: Text;
                        InS: InStream;
                        OverrideImageQst: Label 'The existing picture will be replaced. Do you want to continue?';
                    begin
                        if Rec.Picture.Count > 0 then
                            if not Confirm(OverrideImageQst) then
                                Error('');

                        SourceText := Rec."No." + ', ' + Rec.Description;
                        SwissQRCodeHelper.GenerateQRCodeImage(SourceText, TempBlob);
                        if TempBlob.HasValue() then begin
                            FileName := Rec."No." + '_QR.png';
                            TempBlob.CreateInStream(InS);
                            Clear(Rec.Picture);
                            Rec.Picture.ImportStream(InS, FileName);
                            Rec.Modify(true);
                        end;
                    end;
                }
            }

        }
        addfirst(Promoted)
        {
            actionref(GenerateQRCode_Promoted; GenerateQRCode)
            {
            }
            actionref(GenerateQRImage_promoted; GenerateQRImage)
            {
            }
        }
    }
}
