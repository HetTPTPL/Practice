report 60100 "Latest Proforma Invoice"
{
    ApplicationArea = All;
    Caption = 'Latest Proforma Invoice';
    UsageCategory = ReportsAndAnalysis;
    DefaultRenderingLayout = RDLC;
    dataset
    {
        dataitem(SalesHeader; "Sales Header")
        {
            DataItemTableView = sorting("Document Type", "No.") where("Document Type" = filter('Order'));
            RequestFilterFields = "No.";
            column(No_SalesHeader; "No.")
            {
            }
            column(DocumentType_SalesHeader; "Document Type")
            {
            }
            column(PageNo; PageNo)
            {
            }
            dataitem(CopyLoop; Integer)
            {
                DataItemTableView = sorting(Number);

                dataitem(PageLoop; Integer)
                {
                    DataItemTableView = sorting(Number) where(Number = const(1));
                    column(OutputNo_PageLoop; OutputNo)
                    {
                    }
                    column(CopyText_PageLoop; CopyText)
                    {
                    }
                    column(CompanyAddr1_PageLoop; CompanyAddr[1])
                    {
                    }
                    column(CompanyAddr2_PageLoop; CompanyAddr[2])
                    {
                    }
                    column(CompanyAddr3_PageLoop; CompanyAddr[3])
                    {
                    }
                    column(CompanyAddr4_PageLoop; CompanyAddr[4])
                    {
                    }
                    column(CompanyAddr5_PageLoop; CompanyAddr[5])
                    {
                    }
                    column(CompanyAddr6_PageLoop; CompanyAddr[6])
                    {
                    }
                    column(CompanyAddr7_PageLoop; CompanyAddr[7])
                    {
                    }
                    column(CompanyLogo_PageLoop; CompanyInformation.Picture)
                    {
                    }
                    column(SelltoAddr_PageLoop; SelltoAddr[1])
                    {
                    }
                    column(SelltoAddr2_PageLoop; SelltoAddr[2])
                    {
                    }
                    column(SelltoAddr3_PageLoop; SelltoAddr[3])
                    {
                    }
                    column(SelltoAddr4_PageLoop; SelltoAddr[4])
                    {
                    }
                    column(SelltoAddr5_PageLoop; SelltoAddr[5])
                    {
                    }
                    column(SelltoAddr6_PageLoop; SelltoAddr[6])
                    {
                    }
                    column(SelltoAddr7_PageLoop; SelltoAddr[7])
                    {
                    }
                    column(SelltoAddr8_PageLoop; SelltoAddr[8])
                    {
                    }
                    column(BilltoAddr_PageLoop; BilltoAddr[1])
                    {
                    }
                    column(BilltoAddr2_PageLoop; BilltoAddr[2])
                    {
                    }
                    column(BilltoAddr3; BilltoAddr[3])
                    {
                    }
                    column(BilltoAddr4_PageLoop; BilltoAddr[4])
                    {
                    }
                    column(BilltoAddr5_PageLoop; BilltoAddr[5])
                    {
                    }
                    column(BilltoAddr6_PageLoop; BilltoAddr[6])
                    {
                    }
                    column(BilltoAddr7_PageLoop; BilltoAddr[7])
                    {
                    }
                    column(BilltoAddr8_PageLoop; BilltoAddr[8])
                    {
                    }
                    column(PaymentTermDescription_PageLoop; paymentterms.Description)
                    {
                    }
                    column(PaymentMethodDescription_PageLoop; paymentmethod.Description)
                    {
                    }
                    column(ShipmentMethodDescription_PageLoop; shipmentmethod.Description)
                    {
                    }

                    dataitem(SalesLine; "Sales Line")
                    {
                        DataItemLinkReference = SalesHeader;
                        DataItemLink = "Document Type" = field("Document Type"), "Document No." = field("No.");
                        DataItemTableView = sorting("Document Type", "Document No.", "Line No.") where(Quantity = filter(<> 0));

                        column(No_SalesLine; "No.")
                        {
                        }
                        column(LineNo_SalesLine; "Line No.")
                        {
                        }
                        column(Description_SalesLine; Description)
                        {
                        }
                        column(UnitofMeasureCode_SalesLine; "Unit of Measure Code")
                        {
                        }
                        column(UnitPrice_SalesLine; "Unit Price")
                        {
                        }
                        column(Quantity_SalesLine; Quantity)
                        {
                        }
                        column(LineDiscountAmount_SalesLine; "Line Discount Amount")
                        {
                        }
                        column(LineAmount_SalesLine; "Line Amount")
                        {
                        }
                        column(SrNo; SrNo)
                        {
                        }
                        // column(TotalAmt_SalesLine; TotalAmt)
                        // {
                        // }
                        // column(TotalDiscount_SalesLine; TotalDiscount)
                        // {
                        // }
                        // column(TotalAmountwithoutDiscount_SalesLine; TotalAmountwithoutDiscount)
                        // {
                        // }

                        trigger OnPreDataItem()
                        begin
                            Clear(SrNo);
                            Clear(TotalAmountwithoutDiscount);
                            Clear(TotalDiscount);
                            Clear(TotalAmt);
                            SetFilter(Type, '%1|%2', SalesLine.Type::"G/L Account", SalesLine.Type::Item);
                        end;

                        trigger OnAfterGetRecord()
                        begin
                            SrNo += 1;
                            // TotalAmountwithoutDiscount := TotalAmt - TotalDiscount;
                            // TotalDiscount += "Line Discount Amount";
                            // TotalAmt += "Line Amount";
                        end;
                    }
                    dataitem(BlankLine; Integer)
                    {
                        DataItemTableView = sorting(Number) where(Number = filter('> 0'));

                        column(Number_BlankLine; Number)
                        {
                        }


                        trigger OnPreDataItem()
                        var
                            MaxLine: Integer;
                        begin
                            MaxLine := 43;
                            SalesLine.Reset();
                            SalesLine.SetRange("Document Type", SalesHeader."Document Type");
                            SalesLine.SetRange("Document No.", SalesHeader."No.");
                            SalesLine.SetFilter(Type, '%1|%2', SalesLine.Type::"G/L Account", SalesLine.Type::Item);
                            SalesLine.SetFilter(Quantity, '<>%1', 0);
                            if SalesLine.FindSet() then begin

                                PageNo := SalesLine.Count DIV MaxLine;

                                if ((SalesLine.Count MOD MaxLine) * 100) > 0 then
                                    PageNo += 1;
                                SetRange(Number, 1, Abs(SalesLine.Count - (PageNo * MaxLine)));
                            end;
                        end;
                    }
                }
                trigger OnPreDataItem()
                begin
                    NoofLoop := ABS(NoofCopies) + 1;

                    if NoofLoop <= 0 then
                        NoofLoop := 1;
                    SetRange(Number, 1, NoofLoop);

                    OutputNo := 1;
                end;

                trigger OnAfterGetRecord()
                begin

                    if Number > 1 then
                        OutputNo += 1;
                    if Number = 1 then
                        CopyText := 'Original Copy';
                    if Number = 2 then
                        CopyText := 'Duplicate Copy';
                    if Number >= 3 then
                        CopyText := 'Extra Copy';
                end;
            }

            trigger OnAfterGetRecord()
            var
                FormatAddress: Codeunit "Format Address";
            begin
                FormatAddress.GetCompanyAddr(SalesHeader."Responsibility Center", ResponsibilityCenter, CompanyInformation, CompanyAddr);
                FormatAddress.SalesHeaderSellTo(SelltoAddr, SalesHeader);
                FormatAddress.SalesHeaderBillTo(BilltoAddr, SalesHeader);

                // SelltoAddr[1] := SalesHeader."Sell-to Customer Name";
                // if Contact.Get(SalesHeader."Sell-to Contact No.") then
                //     SelltoAddr[2] := Contact.Name;
                // SelltoAddr[3] := SalesHeader."Sell-to Address";
                // SelltoAddr[4] := SalesHeader."Sell-to Address 2";
                // SelltoAddr[5] := SalesHeader."Sell-to City";
                // SelltoAddr[6] := SalesHeader."Sell-to County";
                // if CountryRegion.Get(SalesHeader."Sell-to Country/Region Code") then
                //     SelltoAddr[7] := CountryRegion.Name;
                // SelltoAddr[8] := SalesHeader."Sell-to Post Code";
                // CompressArray(SelltoAddr);

                // BilltoAddr[1] := SalesHeader."Bill-to Name";
                // if Contact.Get(SalesHeader."Bill-to Contact No.") then
                //     BilltoAddr[2] := Contact.Name;
                // BilltoAddr[3] := SalesHeader."Bill-to Address";
                // BilltoAddr[4] := SalesHeader."Bill-to Address 2";
                // BilltoAddr[5] := SalesHeader."Bill-to City";
                // BilltoAddr[6] := SalesHeader."Bill-to County";
                // if CountryRegion.Get(SalesHeader."Bill-to Country/Region Code") then
                //     BilltoAddr[7] := CountryRegion.Name;
                // BilltoAddr[8] := SalesHeader."Bill-to Post Code";
                // CompressArray(BilltoAddr);

                if paymentterms.Get(SalesHeader."Payment Terms Code") then;
                if paymentmethod.Get(SalesHeader."Payment Method Code") then;
                if shipmentmethod.Get(SalesHeader."Shipment Method Code") then;
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(Options)
                {
                    field(NoofCopies; NoofCopies)
                    {
                        ApplicationArea = all;
                        Caption = 'No. of Copies';
                        ToolTip = 'Specifies the value of the No. of Copies field.';
                    }
                }
            }
        }
        actions
        {
            area(Processing)
            {
            }
        }
    }

    rendering
    {
        layout(RDLC)
        {
            Type = RDLC;
            LayoutFile = './src/Layout/Layout60100_LatestProformaInvoice.rdl';
        }
    }
    labels
    {
        Report_lbl = 'Proforma Invoice';
        Billto_lbl = 'Bill-to';
        Sellto_lbl = 'Sell-to';
        CompanyInfo_lbl = 'Company Information';
        PaymentTerm_lbl = 'Payment Terms';
        ShipmentMethod_lbl = 'Shipment Method';
        PaymentMethod_lbl = 'Payment Method';
        Srno_lbl = 'Sr. No.';
        No_lbl = 'No.';
        Desc_lbl = 'Description';
        UOM_lbl = 'Unit of Measure';
        Rate_lbl = 'Rate';
        Quantity_lbl = 'Quantity';
        LineDis_lbl = 'Line Discount';
        LineAmt_lbl = 'Line Amount';
        AmtinWords_lbl = 'Amount in Words';
        TotLineDis_lbl = 'Total Line Discount';
        TotalAmt_lbl = 'Total Amount';
        AmountPayable_lbl = 'Amount Payable';
        Page_lbl = 'Page ';
        of_lbl = ' of ';
        Paisa_lbl = 'Paisa only';
    }

    trigger OnPreReport()
    begin
        CompanyInformation.Get();
        CompanyInformation.CalcFields(Picture);
    end;

    var
        CompanyInformation: Record "Company Information";
        ResponsibilityCenter: Record "Responsibility Center";
        CountryRegion: Record "Country/Region";
        Contact: Record Contact;
        paymentterms: Record "Payment Terms";
        shipmentmethod: Record "Shipment Method";
        paymentmethod: Record "Payment Method";
        CompanyAddr: array[8] of Text[100];
        SelltoAddr: array[8] of Text[100];
        BilltoAddr: array[8] of Text[100];
        SrNo: Integer;
        TotalAmountwithoutDiscount: Decimal;
        TotalDiscount: Decimal;
        TotalAmt: Decimal;
        PageNo: Integer;
        NoofCopies: Integer;
        NoofLoop: Integer;
        OutputNo: Integer;
        CopyText: Text;

    // local procedure FormatFields(SalesHeader: Record "Sales Header")
    // var
    //     FormatAddress: Codeunit "Format Address";
    //     ResponsibilityCenter: Record "Responsibility Center";
    // begin
    //     FormatAddress.GetCompanyAddr(SalesHeader."Responsibility Center", ResponsibilityCenter, CompanyInformation, CompanyAddr);
    // end;
}
