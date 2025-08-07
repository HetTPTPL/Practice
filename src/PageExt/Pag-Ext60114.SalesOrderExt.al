pageextension 60114 "Sales Order Ext" extends "Sales Order"
{
    actions
    {
        addlast(Processing)
        {
            action("Send Confirmation Email")
            {
                ApplicationArea = All;
                Caption = 'Send Confirmation Email';
                Image = Email;
                trigger OnAction()
                var
                    EmailMgt: Codeunit "Email Mgt";
                    SalesHeader: Record "Sales Header";
                    IsPrinted: Boolean;
                begin
                    begin
                        SalesHeader.Get(Rec."Document Type", Rec."No.");
                        SalesHeader.SetRange("No.", Rec."No.");
                        SalesHeader.SetRange("Document Type", Rec."Document Type");
                        EmailMgt.OnBeforeDoPrintSalesHeader(SalesHeader, 1, true, IsPrinted);
                    end;
                end;
            }
        }
    }
}
