codeunit 60110 "Sales to Posted Sales Comment"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", OnBeforeInsertInvoiceHeader, '', false, false)]
    local procedure "Sales-Post OnBeforeInsertInvoiceHeader"(var SalesInvHeader: Record "Sales Invoice Header"; SalesHeader: Record "Sales Header")
    var
        SalesCmtLn: Record "Sales Comment Line";
        NewSalesCmtLn: Record "Sales Comment Line";
        LineNo: Integer;
    begin
        LineNo := 10000;

        SalesCmtLn.SetRange("Document Type", SalesCmtLn."Document Type"::Order);
        SalesCmtLn.SetRange("No.", SalesHeader."No.");

        if SalesCmtLn.FindSet() then
            repeat
                NewSalesCmtLn.Init();
                NewSalesCmtLn.TransferFields(SalesCmtLn);
                NewSalesCmtLn."Document Type" := NewSalesCmtLn."Document Type"::"Posted Invoice";
                NewSalesCmtLn."No." := SalesInvHeader."No.";
                NewSalesCmtLn."Line No." := LineNo;
                LineNo += 10000;
                NewSalesCmtLn.Insert();
            until SalesCmtLn.Next() = 0;
    end;
}