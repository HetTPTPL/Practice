codeunit 60105 "Sales Order Mgt"
{
    [EventSubscriber(ObjectType::Table, Database::"Sales Header", OnAfterValidateEvent, 'Order Date', false, false)]
    local procedure OnAfterValidateOrderDate(var Rec: Record "Sales Header")
    var
        SalesLine: Record "Sales Line";
    begin
        if Rec."Document Type" <> Rec."Document Type"::Order then
            exit;

        SalesLine.SetRange("Document Type", SalesLine."Document Type"::Order);
        SalesLine.SetRange("Document No.", Rec."No.");
        if SalesLine.FindSet() then
            repeat
                SalesLine."Order Date" := Rec."Order Date";
                SalesLine.Modify();
            until SalesLine.Next() = 0;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", OnAfterValidateEvent, 'Status', false, false)]
    local procedure OnAfterValidateEventStatus(var Rec: Record "Sales Header")
    var
        SalesLine: Record "Sales Line";
    begin
        if Rec."Document Type" <> Rec."Document Type"::Order then
            exit;

        SalesLine.SetRange("Document Type", SalesLine."Document Type"::Order);
        SalesLine.SetRange("Document No.", Rec."No.");
        if SalesLine.FindSet() then
            repeat
                SalesLine.Status := Rec.Status;
                SalesLine.Modify(true);
            until SalesLine.Next() = 0;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", OnAfterValidateEvent, 'No.', false, false)]
    local procedure OnAfterValidateNo(var Rec: Record "Sales Line")
    var
        SalesHeader: Record "Sales Header";
    begin
        if Rec."Document Type" <> Rec."Document Type"::Order then
            exit;

        if SalesHeader.Get(Rec."Document Type", Rec."Document No.") then begin
            Rec."Order Date" := SalesHeader."Order Date";
            Rec.Status := SalesHeader.Status;
        end;
    end;
}
