codeunit 60101 "Item Card Mgt."
{
    procedure ShowCreditMemoLine(var ItemRec: Record Item)
    var
        SalesHeaderRec: Record "Sales Header";
        SalesLineRec: Record "Sales Line";
        SalesLineTemp: Record "Sales Line";
    begin
        SalesHeaderRec.Reset();
        SalesHeaderRec.SetRange("Document Type", SalesHeaderRec."Document Type"::"Credit Memo");
        SalesHeaderRec.SetRange(Status, SalesHeaderRec.Status::Released);

        if SalesHeaderRec.FindSet() then
            repeat
                SalesLineRec.Reset();
                SalesLineRec.SetRange("Document Type", SalesLineRec."Document Type"::"Credit Memo");
                SalesLineRec.SetRange("Document No.", SalesHeaderRec."No.");
                SalesLineRec.SetRange(Type, SalesLineRec.Type::Item);
                SalesLineRec.SetRange("No.", ItemRec."No.");
                SalesLineRec.SetRange("Line Amount", 100, 10000);

                if SalesLineRec.FindSet() then
                    repeat
                        SalesLineTemp := SalesLineRec;
                        SalesLineTemp.Mark(true);
                    until SalesLineRec.Next() = 0;

            until SalesHeaderRec.Next() = 0;

        SalesLineTemp.MarkedOnly(true);
        Page.Run(Page::"Sales Lines", SalesLineTemp);
    end;
}
