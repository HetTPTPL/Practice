report 60102 Practice
{
    ApplicationArea = All;
    Caption = 'Practice';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './src/Layout/Practice.rdl';
    dataset
    {
        dataitem(ILE; "Item Ledger Entry")
        {
            //     DataItemTableView =
            // sorting("Item No.")
            // where(
            //     "Document Type" = const("Sales Shipment"),
            //     "Source Type" = const(Customer),
            //     "Source No." = filter('30000|20000')
            // );
            RequestFilterFields = "Posting Date";
            column(Source_No_; "Source No.")
            { }
            column(ItemCode; "Item No.") { }
            column(ItemName; ItemName) { }
            column(DailySalesQty; DailySalesQty) { }
            column(CummSalesQty; CummSalesQty) { }
            column(RatePerKg; RatePerKg) { }
            column(TotalValue; TotalValue) { }

            trigger OnPreDataItem()
            begin
                // Apply Filters
                SetRange("Posting Date", StartDate, EndDate);
                SetRange("Document Type", "Document Type"::"Sales Shipment");
                SetRange("Source Type", "Source Type"::Customer);
                SetFilter("Source No.", '30000|20000');
            end;

            trigger OnAfterGetRecord()
            var
                ItemRec: Record Item;
            begin
                Clear(DailySalesQty);
                Clear(CummSalesQty);
                Clear(TotalValue);
                Clear(RatePerKg);

                // Get Item Name
                if ItemRec.Get("Item No.") then
                    ItemName := ItemRec.Description;

                // Cumulative Qty & Value
                CummSalesQty := CalcSumQty("Item No.", "Source No.", StartDate, EndDate);
                TotalValue := CalcTotalValue("Item No.", "Source No.", StartDate, EndDate);

                // Daily Qty on End Date
                DailySalesQty := CalcDailyQty("Item No.", "Source No.", EndDate);

                if CummSalesQty <> 0 then
                    RatePerKg := TotalValue / CummSalesQty;
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(content)
            {
                field(StartDate; StartDate)
                {
                    ApplicationArea = All;
                }
                field(EndDate; EndDate)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    var
        StartDate: Date;
        EndDate: Date;
        DailySalesQty: Decimal;
        CummSalesQty: Decimal;
        TotalValue: Decimal;
        RatePerKg: Decimal;
        ItemName: Text[100];

    local procedure CalcSumQty(ItemNo: Code[20]; SourceNo: Code[20]; FromDate: Date; ToDate: Date): Decimal
    var
        ILE2: Record "Item Ledger Entry";
        exitValue: Decimal;
    begin
        ILE2.Reset();
        ILE2.SetRange("Item No.", ItemNo);
        ILE2.SetRange("Posting Date", FromDate, ToDate);
        ILE2.SetRange("Document Type", ILE2."Document Type"::"Sales Shipment");
        ILE2.SetRange("Source Type", ILE2."Source Type"::Customer);
        ILE2.SetFilter("Source No.", SourceNo);
        if ILE2.FindSet() then
            repeat
                exitValue += ILE2.Quantity;
            until ILE2.Next() = 0;
        exit(exitValue);
    end;

    local procedure CalcDailyQty(ItemNo: Code[20]; SourceNo: Code[20]; SpecificDate: Date): Decimal
    var
        ILE2: Record "Item Ledger Entry";
        exitValue: Decimal;
    begin
        ILE2.Reset();
        ILE2.SetRange("Item No.", ItemNo);
        ILE2.SetRange("Posting Date", SpecificDate);
        ILE2.SetRange("Document Type", ILE2."Document Type"::"Sales Shipment");
        ILE2.SetRange("Source Type", ILE2."Source Type"::Customer);
        ILE2.SetFilter("Source No.", SourceNo);
        if ILE2.FindSet() then
            repeat
                exitValue += ILE2.Quantity;
            until ILE2.Next() = 0;
        exit(exitValue);
    end;

    local procedure CalcTotalValue(ItemNo: Code[20]; SourceNo: Code[20]; FromDate: Date; ToDate: Date): Decimal
    var
        ILE2: Record "Item Ledger Entry";
        exitValue: Decimal;
        Count: Integer;
    begin
        ILE2.Reset();
        ILE2.SetRange("Item No.", ItemNo);
        ILE2.SetRange("Posting Date", FromDate, ToDate);
        ILE2.SetRange("Document Type", ILE2."Document Type"::"Sales Shipment");
        ILE2.SetRange("Source Type", ILE2."Source Type"::Customer);
        ILE2.SetFilter("Source No.", SourceNo);
        if ILE2.FindSet() then
            repeat
                ILE2.CalcFields("Sales Amount (Actual)"); // <-- This is required for FlowField
                exitValue += ILE2."Sales Amount (Actual)";
                Count += 1;
            until ILE2.Next() = 0;
        Message('Found %1 records for Item %2, TotalValue: %3', Count, ItemNo, exitValue);
        exit(exitValue);
    end;
}
