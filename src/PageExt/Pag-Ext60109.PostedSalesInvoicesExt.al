pageextension 60109 "Posted Sales Invoices Ext" extends "Posted Sales Invoices"
{
    actions
    {
        addlast(processing)
        {
            action(IsSame)
            {
                ApplicationArea = all;
                Caption = 'Is Same?';
                Image = Calculate;

                trigger OnAction()
                var
                    SalesInvHdr: Record "Sales Invoice Header";
                begin
                    CurrPage.SetSelectionFilter(SalesInvHdr);
                    if SalesInvHdr.FindSet() then
                        CheckDistinctCustomerNo(SalesInvHdr);
                end;
            }
            action(FindDuplicates)
            {
                Caption = 'Find Duplicates';
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = FilterLines;

                trigger OnAction()
                var
                    DuplicatesFilter: Text[2048];
                begin
                    DuplicatesFilter := FindDuplicates(Database::"Sales Invoice Header", 79);
                    Message(DuplicatesFilter);
                    Rec.SetFilter("Sell-to Customer Name", DuplicatesFilter);
                    CurrPage.Update();
                end;
            }
            action(ToggleClosed)
            {
                Caption = 'Toggle Closed';
                Image = Process;
                ApplicationArea = All;
                trigger OnAction()
                var
                    SalesInvoiceHeader: Record "Sales Invoice Header";
                begin
                    SalesInvoiceHeader.Get(Rec."No.");
                    SalesInvoiceHeader."Closed" := not SalesInvoiceHeader."Closed";
                    SalesInvoiceHeader.Modify();
                    Rec := SalesInvoiceHeader; // Refresh page variable
                    Message('Closed set to %1', Format(SalesInvoiceHeader."Closed"));
                end;
            }
        }
    }
    var
        DistinctCustomerErr: Label 'The customer must be same value on all lines you selected.';

    local procedure CheckDistinctCustomerNo(var SalesInvHdr: Record "Sales Invoice Header")
    var
        CountBefore: Integer;
        CountAfter: Integer;
    begin
        Clear(CountBefore);
        Clear(CountAfter);
        CountBefore := SalesInvHdr.Count;
        SalesInvHdr.SetRange("Sell-to Customer No.", SalesInvHdr."Sell-to Customer No.");
        CountAfter := SalesInvHdr.Count;
        if CountBefore <> CountAfter then
            Error(DistinctCustomerErr)
        else
            Message('OK');
        SalesInvHdr.SetRange("Sell-to Customer No.");
    end;

    local procedure FindDuplicates(TableID: Integer; FieldID: Integer) DuplicatesFilter: Text[2048]
    var
        RecRef: RecordRef;
        FldRef: FieldRef;
        RecRef2: RecordRef;
        FldRef2: FieldRef;
        FilterText: Text[100];
    begin
        Clear(RecRef);
        Clear(FldRef);
        DuplicatesFilter := '';
        FilterText := '';
        RecRef.Open(TableID);
        FldRef := RecRef.Field(FieldID);
        RecRef.SetView(StrSubstNo('SORTING(%1)', FldRef.Caption));
        RecRef.Ascending(true);
        if RecRef.FindSet() then
            repeat
                if FilterText <> Format(FldRef.Value) then begin
                    RecRef2.Open(TableID);
                    FldRef2 := RecRef2.Field(FieldID);
                    FldRef2.SetFilter(FldRef.Value);
                    if RecRef2.FindSet() then
                        if RecRef2.Count > 1 then begin
                            FilterText := Format(FldRef2.Value);
                            if DuplicatesFilter = '' then
                                DuplicatesFilter := Format(FldRef2.Value)
                            else
                                DuplicatesFilter := DuplicatesFilter + '|' + Format(FldRef2.Value);
                        end;
                    RecRef2.Close();
                end;
            until RecRef.Next() = 0;
    end;
}
