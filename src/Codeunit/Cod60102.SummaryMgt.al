codeunit 60102 "Summary Mgt."
{
    procedure CheckRecExist(Type: Enum Type; No: Code[20])
    var
        SummaryRec: Record "Summary Table";
    begin
        SummaryRec.Reset();
        SummaryRec.SetRange(Type, Type);
        SummaryRec.SetRange("No.", No);
        if SummaryRec.FindFirst() then
            DeleteExistRec(SummaryRec);
        InsertSummary(Type, No);
    end;

    procedure DeleteExistRec(SummaryRec: Record "Summary Table")
    begin
        SummaryRec.Delete();
    end;

    procedure InsertSummary(TypeFilter: Enum Type; NoFilter: Code[20])
    begin
        if TypeFilter = TypeFilter::Item then
            InsertSummaryforItem(TypeFilter, NoFilter)
        else if TypeFilter = TypeFilter::Customer then
            InsertSummaryforCustomer(TypeFilter, NoFilter)
        else if TypeFilter = TypeFilter::Vendor then
            InsertSummaryforVendor(TypeFilter, NoFilter)
        else if TypeFilter = TypeFilter::"G/L Account" then
            InsertSummaryforGLAccount(TypeFilter, NoFilter)
        else if TypeFilter = TypeFilter::"Fixed Asset" then
            InsertSummaryforFixedAsset(TypeFilter, NoFilter)
    end;

    procedure InsertSummaryforItem(TypeFilter: Enum Type; NoFilter: Code[20])
    var
        SalesHeaderRec: Record "Sales Header";
        SalesLineRec: Record "Sales Line";
        PurchaseHeaderRec: Record "Purchase Header";
        PurchaseLineRec: Record "Purchase Line";
        InsertSummaryRec: Record "Summary Table";
        LastSummaryRec: Record "Summary Table";
        Sales: Decimal;
        Purchase: Decimal;
        EntryNo: Integer;
    begin
        SalesHeaderRec.Reset();
        SalesHeaderRec.SetFilter("Document Type", '%1|%2', SalesHeaderRec."Document Type"::Order, SalesHeaderRec."Document Type"::Invoice);
        SalesHeaderRec.SetRange(Status, SalesHeaderRec.Status::Released);

        if SalesHeaderRec.FindSet() then
            repeat
                SalesLineRec.Reset();
                SalesLineRec.SetFilter("Document Type", '%1|%2', SalesLineRec."Document Type"::Order, SalesLineRec."Document Type"::Invoice);
                SalesLineRec.SetRange("Document No.", SalesHeaderRec."No.");
                SalesLineRec.SetRange(Type, SalesLineRec.Type::Item);
                SalesLineRec.SetRange("No.", NoFilter);

                if SalesLineRec.FindSet() then
                    repeat
                        Sales += SalesLineRec.Amount;
                    until SalesLineRec.Next() = 0;
            until SalesHeaderRec.Next() = 0;

        PurchaseHeaderRec.Reset();
        PurchaseHeaderRec.SetFilter("Document Type", '%1|%2', PurchaseHeaderRec."Document Type"::Order, PurchaseHeaderRec."Document Type"::Invoice);
        PurchaseHeaderRec.SetRange(Status, PurchaseHeaderRec.Status::Released);

        if PurchaseHeaderRec.FindSet() then
            repeat
                PurchaseLineRec.Reset();
                PurchaseLineRec.SetFilter("Document Type", '%1|%2', PurchaseLineRec."Document Type"::Order, PurchaseLineRec."Document Type"::Invoice);
                PurchaseLineRec.SetRange("Document No.", PurchaseHeaderRec."No.");
                PurchaseLineRec.SetRange(Type, PurchaseLineRec.Type::Item);
                PurchaseLineRec.SetRange("No.", NoFilter);

                if PurchaseLineRec.FindSet() then
                    repeat
                        Purchase += PurchaseLineRec.Amount;
                    until PurchaseLineRec.Next() = 0;
            until PurchaseHeaderRec.Next() = 0;

        LastSummaryRec.Reset();
        if LastSummaryRec.FindLast() then
            EntryNo := LastSummaryRec."Entry No." + 1
        else
            EntryNo := 1;

        InsertSummaryRec.Init();
        InsertSummaryRec."Entry No." := EntryNo;
        InsertSummaryRec.Type := TypeFilter;
        InsertSummaryRec.Validate("No.", NoFilter);
        InsertSummaryRec."Sales Total" := Sales;
        InsertSummaryRec."Purchase Total" := Purchase;
        InsertSummaryRec.Insert();
    end;

    procedure InsertSummaryforCustomer(TypeFilter: Enum Type; NoFilter: Code[20])
    var
        SalesHeaderRec: Record "Sales Header";
        InsertSummaryRec: Record "Summary Table";
        LastSummaryRec: Record "Summary Table";
        Sales: Decimal;
        EntryNo: Integer;
    begin
        SalesHeaderRec.Reset();
        SalesHeaderRec.SetFilter("Document Type", '%1|%2', SalesHeaderRec."Document Type"::Order, SalesHeaderRec."Document Type"::Invoice);
        SalesHeaderRec.SetRange(Status, SalesHeaderRec.Status::Released);
        SalesHeaderRec.SetRange("Sell-to Customer No.", NoFilter);

        if SalesHeaderRec.FindSet() then
            repeat
                SalesHeaderRec.CalcFields(Amount);
                Sales += SalesHeaderRec.Amount;
            until SalesHeaderRec.Next() = 0;

        LastSummaryRec.Reset();
        if LastSummaryRec.FindLast() then
            EntryNo := LastSummaryRec."Entry No." + 1
        else
            EntryNo := 1;

        InsertSummaryRec.Init();
        InsertSummaryRec."Entry No." := EntryNo;
        InsertSummaryRec.Type := TypeFilter;
        InsertSummaryRec.Validate("No.", NoFilter);
        InsertSummaryRec."Sales Total" := Sales;
        InsertSummaryRec.Insert();
    end;

    procedure InsertSummaryforVendor(TypeFilter: Enum Type; NoFilter: Code[20])
    var
        PurchaseHeaderRec: Record "Purchase Header";
        InsertSummaryRec: Record "Summary Table";
        LastSummaryRec: Record "Summary Table";
        Purchase: Decimal;
        EntryNo: Integer;
    begin
        PurchaseHeaderRec.Reset();
        PurchaseHeaderRec.SetFilter("Document Type", '%1|%2', PurchaseHeaderRec."Document Type"::Order, PurchaseHeaderRec."Document Type"::Invoice);
        PurchaseHeaderRec.SetRange(Status, PurchaseHeaderRec.Status::Released);
        PurchaseHeaderRec.SetRange("Buy-from Vendor No.", NoFilter);

        if PurchaseHeaderRec.FindSet() then
            repeat
                PurchaseHeaderRec.CalcFields(Amount);
                Purchase += PurchaseHeaderRec.Amount;
            until PurchaseHeaderRec.Next() = 0;


        LastSummaryRec.Reset();
        if LastSummaryRec.FindLast() then
            EntryNo := LastSummaryRec."Entry No." + 1
        else
            EntryNo := 1;

        InsertSummaryRec.Init();
        InsertSummaryRec."Entry No." := EntryNo;
        InsertSummaryRec.Type := TypeFilter;
        InsertSummaryRec.Validate("No.", NoFilter);
        InsertSummaryRec."Purchase Total" := Purchase;
        InsertSummaryRec.Insert();
    end;

    procedure InsertSummaryforGLAccount(TypeFilter: Enum Type; NoFilter: Code[20])
    var
        SalesHeaderRec: Record "Sales Header";
        SalesLineRec: Record "Sales Line";
        PurchaseHeaderRec: Record "Purchase Header";
        PurchaseLineRec: Record "Purchase Line";
        InsertSummaryRec: Record "Summary Table";
        LastSummaryRec: Record "Summary Table";
        Sales: Decimal;
        Purchase: Decimal;
        EntryNo: Integer;
    begin
        SalesHeaderRec.Reset();
        SalesHeaderRec.SetFilter("Document Type", '%1|%2', SalesHeaderRec."Document Type"::Order, SalesHeaderRec."Document Type"::Invoice);
        SalesHeaderRec.SetRange(Status, SalesHeaderRec.Status::Released);

        if SalesHeaderRec.FindSet() then
            repeat
                SalesLineRec.Reset();
                SalesLineRec.SetFilter("Document Type", '%1|%2', SalesLineRec."Document Type"::Order, SalesLineRec."Document Type"::Invoice);
                SalesLineRec.SetRange("Document No.", SalesHeaderRec."No.");
                SalesLineRec.SetRange(Type, SalesLineRec.Type::"G/L Account");
                SalesLineRec.SetRange("No.", NoFilter);

                if SalesLineRec.FindSet() then
                    repeat
                        Sales += SalesLineRec.Amount;
                    until SalesLineRec.Next() = 0;
            until SalesHeaderRec.Next() = 0;

        PurchaseHeaderRec.Reset();
        PurchaseHeaderRec.SetFilter("Document Type", '%1|%2', PurchaseHeaderRec."Document Type"::Order, PurchaseHeaderRec."Document Type"::Invoice);
        PurchaseHeaderRec.SetRange(Status, PurchaseHeaderRec.Status::Released);

        if PurchaseHeaderRec.FindSet() then
            repeat
                PurchaseLineRec.Reset();
                PurchaseLineRec.SetFilter("Document Type", '%1|%2', PurchaseLineRec."Document Type"::Order, PurchaseLineRec."Document Type"::Invoice);
                PurchaseLineRec.SetRange("Document No.", PurchaseHeaderRec."No.");
                PurchaseLineRec.SetRange(Type, PurchaseLineRec.Type::"G/L Account");
                PurchaseLineRec.SetRange("No.", NoFilter);

                if PurchaseLineRec.FindSet() then
                    repeat
                        Purchase += PurchaseLineRec.Amount;
                    until PurchaseLineRec.Next() = 0;
            until PurchaseHeaderRec.Next() = 0;

        LastSummaryRec.Reset();
        if LastSummaryRec.FindLast() then
            EntryNo := LastSummaryRec."Entry No." + 1
        else
            EntryNo := 1;

        InsertSummaryRec.Init();
        InsertSummaryRec."Entry No." := EntryNo;
        InsertSummaryRec.Type := TypeFilter;
        InsertSummaryRec.Validate("No.", NoFilter);
        InsertSummaryRec."Sales Total" := Sales;
        InsertSummaryRec."Purchase Total" := Purchase;
        InsertSummaryRec.Insert();
    end;

    procedure InsertSummaryforFixedAsset(TypeFilter: Enum Type; NoFilter: Code[20])
    var
        SalesHeaderRec: Record "Sales Header";
        SalesLineRec: Record "Sales Line";
        PurchaseHeaderRec: Record "Purchase Header";
        PurchaseLineRec: Record "Purchase Line";
        InsertSummaryRec: Record "Summary Table";
        LastSummaryRec: Record "Summary Table";
        Sales: Decimal;
        Purchase: Decimal;
        EntryNo: Integer;
    begin
        SalesHeaderRec.Reset();
        SalesHeaderRec.SetFilter("Document Type", '%1|%2', SalesHeaderRec."Document Type"::Order, SalesHeaderRec."Document Type"::Invoice);
        SalesHeaderRec.SetRange(Status, SalesHeaderRec.Status::Released);

        if SalesHeaderRec.FindSet() then
            repeat
                SalesLineRec.Reset();
                SalesLineRec.SetFilter("Document Type", '%1|%2', SalesLineRec."Document Type"::Order, SalesLineRec."Document Type"::Invoice);
                SalesLineRec.SetRange("Document No.", SalesHeaderRec."No.");
                SalesLineRec.SetRange(Type, SalesLineRec.Type::"Fixed Asset");
                SalesLineRec.SetRange("No.", NoFilter);

                if SalesLineRec.FindSet() then
                    repeat
                        Sales += SalesLineRec.Amount;
                    until SalesLineRec.Next() = 0;
            until SalesHeaderRec.Next() = 0;

        PurchaseHeaderRec.Reset();
        PurchaseHeaderRec.SetFilter("Document Type", '%1|%2', PurchaseHeaderRec."Document Type"::Order, PurchaseHeaderRec."Document Type"::Invoice);
        PurchaseHeaderRec.SetRange(Status, PurchaseHeaderRec.Status::Released);

        if PurchaseHeaderRec.FindSet() then
            repeat
                PurchaseLineRec.Reset();
                PurchaseLineRec.SetFilter("Document Type", '%1|%2', PurchaseLineRec."Document Type"::Order, PurchaseLineRec."Document Type"::Invoice);
                PurchaseLineRec.SetRange("Document No.", PurchaseHeaderRec."No.");
                PurchaseLineRec.SetRange(Type, PurchaseLineRec.Type::"Fixed Asset");
                PurchaseLineRec.SetRange("No.", NoFilter);

                if PurchaseLineRec.FindSet() then
                    repeat
                        Purchase += PurchaseLineRec.Amount;
                    until PurchaseLineRec.Next() = 0;
            until PurchaseHeaderRec.Next() = 0;

        LastSummaryRec.Reset();
        if LastSummaryRec.FindLast() then
            EntryNo := LastSummaryRec."Entry No." + 1
        else
            EntryNo := 1;

        InsertSummaryRec.Init();
        InsertSummaryRec."Entry No." := EntryNo;
        InsertSummaryRec.Type := TypeFilter;
        InsertSummaryRec.Validate("No.", NoFilter);
        InsertSummaryRec."Sales Total" := Sales;
        InsertSummaryRec."Purchase Total" := Purchase;
        InsertSummaryRec.Insert();
    end;

    procedure DrillDownSales(TypeFilter: Enum Type; NoFilter: Code[20])
    begin
        if TypeFilter = TypeFilter::Item then
            DrillDownSalesItem(TypeFilter, NoFilter)
        else if TypeFilter = TypeFilter::Customer then
            DrillDownSalesCustomer(TypeFilter, NoFilter)
        else if TypeFilter = TypeFilter::"G/L Account" then
            DrillDownSalesGLAccount(TypeFilter, NoFilter)
        else if TypeFilter = TypeFilter::"Fixed Asset" then
            DrillDownSalesFixedAsset(TypeFilter, NoFilter)
    end;

    procedure DrillDownSalesCustomer(TypeFilter: Enum Type; NoFilter: Code[20])
    var
        SalesHeaderRec: Record "Sales Header";
        SalesLineRec: Record "Sales Line";
        SalesLineTemp: Record "Sales Line";
    begin
        SalesHeaderRec.Reset();
        SalesHeaderRec.SetFilter("Document Type", '%1|%2', SalesHeaderRec."Document Type"::Order, SalesHeaderRec."Document Type"::Invoice);
        SalesHeaderRec.SetRange(Status, SalesHeaderRec.Status::Released);
        SalesHeaderRec.SetRange("Sell-to Customer No.", NoFilter);

        if SalesHeaderRec.FindSet() then
            repeat
                SalesLineRec.SetFilter("Document Type", '%1|%2', SalesLineRec."Document Type"::Order, SalesLineRec."Document Type"::Invoice);
                SalesLineRec.SetRange("Document No.", SalesHeaderRec."No.");

                if SalesLineRec.FindSet() then
                    repeat
                        SalesLineTemp := SalesLineRec;
                        SalesLineTemp.Mark(true);
                    until SalesLineRec.Next() = 0;
            until SalesHeaderRec.Next() = 0;

        SalesLineTemp.MarkedOnly(true);
        Page.Run(Page::"Sales Lines", SalesLineTemp);
    end;

    procedure DrillDownSalesItem(TypeFilter: Enum Type; NoFilter: Code[20])
    var
        SalesHeaderRec: Record "Sales Header";
        SalesLineRec: Record "Sales Line";
        SalesLineTemp: Record "Sales Line";
    begin
        SalesHeaderRec.Reset();
        SalesHeaderRec.SetFilter("Document Type", '%1|%2', SalesHeaderRec."Document Type"::Order, SalesHeaderRec."Document Type"::Invoice);
        SalesHeaderRec.SetRange(Status, SalesHeaderRec.Status::Released);

        if SalesHeaderRec.FindSet() then
            repeat
                SalesLineRec.Reset();
                SalesLineRec.SetFilter("Document Type", '%1|%2', SalesLineRec."Document Type"::Order, SalesLineRec."Document Type"::Invoice);
                SalesLineRec.SetRange("Document No.", SalesHeaderRec."No.");
                SalesLineRec.SetRange(Type, SalesLineRec.Type::Item);
                SalesLineRec.SetRange("No.", NoFilter);

                if SalesLineRec.FindSet() then
                    repeat
                        SalesLineTemp := SalesLineRec;
                        SalesLineTemp.Mark(true);
                    until SalesLineRec.Next() = 0;
            until SalesHeaderRec.Next() = 0;

        SalesLineTemp.MarkedOnly(true);
        Page.Run(Page::"Sales Lines", SalesLineTemp);
    end;

    procedure DrillDownSalesGLAccount(TypeFilter: Enum Type; NoFilter: Code[20])
    var
        SalesHeaderRec: Record "Sales Header";
        SalesLineRec: Record "Sales Line";
        SalesLineTemp: Record "Sales Line";
    begin
        SalesHeaderRec.Reset();
        SalesHeaderRec.SetFilter("Document Type", '%1|%2', SalesHeaderRec."Document Type"::Order, SalesHeaderRec."Document Type"::Invoice);
        SalesHeaderRec.SetRange(Status, SalesHeaderRec.Status::Released);

        if SalesHeaderRec.FindSet() then
            repeat
                SalesLineRec.Reset();
                SalesLineRec.SetFilter("Document Type", '%1|%2', SalesLineRec."Document Type"::Order, SalesLineRec."Document Type"::Invoice);
                SalesLineRec.SetRange("Document No.", SalesHeaderRec."No.");
                SalesLineRec.SetRange(Type, SalesLineRec.Type::"G/L Account");
                SalesLineRec.SetRange("No.", NoFilter);

                if SalesLineRec.FindSet() then
                    repeat
                        SalesLineTemp := SalesLineRec;
                        SalesLineTemp.Mark(true);
                    until SalesLineRec.Next() = 0;
            until SalesHeaderRec.Next() = 0;

        SalesLineTemp.MarkedOnly(true);
        Page.Run(Page::"Sales Lines", SalesLineTemp);
    end;

    procedure DrillDownSalesFixedAsset(TypeFilter: Enum Type; NoFilter: Code[20])
    var
        SalesHeaderRec: Record "Sales Header";
        SalesLineRec: Record "Sales Line";
        SalesLineTemp: Record "Sales Line";
    begin
        SalesHeaderRec.Reset();
        SalesHeaderRec.SetFilter("Document Type", '%1|%2', SalesHeaderRec."Document Type"::Order, SalesHeaderRec."Document Type"::Invoice);
        SalesHeaderRec.SetRange(Status, SalesHeaderRec.Status::Released);

        if SalesHeaderRec.FindSet() then
            repeat
                SalesLineRec.Reset();
                SalesLineRec.SetFilter("Document Type", '%1|%2', SalesLineRec."Document Type"::Order, SalesLineRec."Document Type"::Invoice);
                SalesLineRec.SetRange("Document No.", SalesHeaderRec."No.");
                SalesLineRec.SetRange(Type, SalesLineRec.Type::"Fixed Asset");
                SalesLineRec.SetRange("No.", NoFilter);

                if SalesLineRec.FindSet() then
                    repeat
                        SalesLineTemp := SalesLineRec;
                        SalesLineTemp.Mark(true);
                    until SalesLineRec.Next() = 0;
            until SalesHeaderRec.Next() = 0;

        SalesLineTemp.MarkedOnly(true);
        Page.Run(Page::"Sales Lines", SalesLineTemp);
    end;

    procedure DrillDownPurchase(TypeFilter: Enum Type; NoFilter: Code[20])
    begin
        if TypeFilter = TypeFilter::Item then
            DrillDownPurchaseItem(TypeFilter, NoFilter)
        else if TypeFilter = TypeFilter::Vendor then
            DrillDownPurchaseVendor(TypeFilter, NoFilter)
        else if TypeFilter = TypeFilter::"G/L Account" then
            DrillDownPurchaseGLAccount(TypeFilter, NoFilter)
        else if TypeFilter = TypeFilter::"Fixed Asset" then
            DrillDownPurchaseFixedAsset(TypeFilter, NoFilter)
    end;

    procedure DrillDownPurchaseVendor(TypeFilter: Enum Type; NoFilter: Code[20])
    var
        PurchaseHeaderRec: Record "Purchase Header";
        PurchaseLineRec: Record "Purchase Line";
        PurchaseLineTemp: Record "Purchase Line";
    begin
        PurchaseHeaderRec.Reset();
        PurchaseHeaderRec.SetFilter("Document Type", '%1|%2', PurchaseHeaderRec."Document Type"::Order, PurchaseHeaderRec."Document Type"::Invoice);
        PurchaseHeaderRec.SetRange(Status, PurchaseHeaderRec.Status::Released);
        PurchaseHeaderRec.SetRange("Buy-from Vendor No.", NoFilter);
        

        if PurchaseHeaderRec.FindSet() then
            repeat
                PurchaseLineRec.SetFilter("Document Type", '%1|%2', PurchaseLineRec."Document Type"::Order, PurchaseLineRec."Document Type"::Invoice);
                PurchaseLineRec.SetRange("Document No.", PurchaseHeaderRec."No.");
                
                if PurchaseLineRec.FindSet() then
                    repeat
                        PurchaseLineTemp := PurchaseLineRec;
                        PurchaseLineTemp.Mark(true);
                    until PurchaseLineRec.Next() = 0;
            until PurchaseHeaderRec.Next() = 0;

        PurchaseLineTemp.MarkedOnly(true);
        Page.Run(Page::"Purchase Lines", PurchaseLineTemp);
    end;

    procedure DrillDownPurchaseItem(TypeFilter: Enum Type; NoFilter: Code[20])
    var
        PurchaseHeaderRec: Record "Purchase Header";
        PurchaseLineRec: Record "Purchase Line";
        PurchaseLineTemp: Record "Purchase Line";
    begin
        PurchaseHeaderRec.Reset();
        PurchaseHeaderRec.SetFilter("Document Type", '%1|%2', PurchaseHeaderRec."Document Type"::Order, PurchaseHeaderRec."Document Type"::Invoice);
        PurchaseHeaderRec.SetRange(Status, PurchaseHeaderRec.Status::Released);

        if PurchaseHeaderRec.FindSet() then
            repeat
                PurchaseLineRec.Reset();
                PurchaseLineRec.SetFilter("Document Type", '%1|%2', PurchaseLineRec."Document Type"::Order, PurchaseLineRec."Document Type"::Invoice);
                PurchaseLineRec.SetRange("Document No.", PurchaseHeaderRec."No.");
                PurchaseLineRec.SetRange(Type, PurchaseLineRec.Type::Item);
                PurchaseLineRec.SetRange("No.", NoFilter);

                if PurchaseLineRec.FindSet() then
                    repeat
                        PurchaseLineTemp := PurchaseLineRec;
                        PurchaseLineTemp.Mark(true);
                    until PurchaseLineRec.Next() = 0;
            until PurchaseHeaderRec.Next() = 0;

        PurchaseLineTemp.MarkedOnly(true);
        Page.Run(Page::"Purchase Lines", PurchaseLineTemp);
    end;

    procedure DrillDownPurchaseGLAccount(TypeFilter: Enum Type; NoFilter: Code[20])
    var
        PurchaseHeaderRec: Record "Purchase Header";
        PurchaseLineRec: Record "Purchase Line";
        PurchaseLineTemp: Record "Purchase Line";
    begin
        PurchaseHeaderRec.Reset();
        PurchaseHeaderRec.SetFilter("Document Type", '%1|%2', PurchaseHeaderRec."Document Type"::Order, PurchaseHeaderRec."Document Type"::Invoice);
        PurchaseHeaderRec.SetRange(Status, PurchaseHeaderRec.Status::Released);

        if PurchaseHeaderRec.FindSet() then
            repeat
                PurchaseLineRec.Reset();
                PurchaseLineRec.SetFilter("Document Type", '%1|%2', PurchaseLineRec."Document Type"::Order, PurchaseLineRec."Document Type"::Invoice);
                PurchaseLineRec.SetRange("Document No.", PurchaseHeaderRec."No.");
                PurchaseLineRec.SetRange(Type, PurchaseLineRec.Type::"G/L Account");
                PurchaseLineRec.SetRange("No.", NoFilter);

                if PurchaseLineRec.FindSet() then
                    repeat
                        PurchaseLineTemp := PurchaseLineRec;
                        PurchaseLineTemp.Mark(true);
                    until PurchaseLineRec.Next() = 0;
            until PurchaseHeaderRec.Next() = 0;

        PurchaseLineTemp.MarkedOnly(true);
        Page.Run(Page::"Purchase Lines", PurchaseLineTemp);
    end;

    procedure DrillDownPurchaseFixedAsset(TypeFilter: Enum Type; NoFilter: Code[20])
    var
        PurchaseHeaderRec: Record "Purchase Header";
        PurchaseLineRec: Record "Purchase Line";
        PurchaseLineTemp: Record "Purchase Line";
    begin
        PurchaseHeaderRec.Reset();
        PurchaseHeaderRec.SetFilter("Document Type", '%1|%2', PurchaseHeaderRec."Document Type"::Order, PurchaseHeaderRec."Document Type"::Invoice);
        PurchaseHeaderRec.SetRange(Status, PurchaseHeaderRec.Status::Released);

        if PurchaseHeaderRec.FindSet() then
            repeat
                PurchaseLineRec.Reset();
                PurchaseLineRec.SetFilter("Document Type", '%1|%2', PurchaseLineRec."Document Type"::Order, PurchaseLineRec."Document Type"::Invoice);
                PurchaseLineRec.SetRange("Document No.", PurchaseHeaderRec."No.");
                PurchaseLineRec.SetRange(Type, PurchaseLineRec.Type::"Fixed Asset");
                PurchaseLineRec.SetRange("No.", NoFilter);

                if PurchaseLineRec.FindSet() then
                    repeat
                        PurchaseLineTemp := PurchaseLineRec;
                        PurchaseLineTemp.Mark(true);
                    until PurchaseLineRec.Next() = 0;
            until PurchaseHeaderRec.Next() = 0;

        PurchaseLineTemp.MarkedOnly(true);
        Page.Run(Page::"Purchase Lines", PurchaseLineTemp);
    end;
}
