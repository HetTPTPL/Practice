pageextension 60113 "Payment Terms Ext" extends "Payment Terms"
{
    layout
    {
        addafter(Description)
        {
            field(TestBoolean1; TestBoolean1)
            {
                ApplicationArea = all;
                Caption = 'Test Boolean 1';
                ToolTip = 'Specifies the value of the Test Boolean 1 field.';
            }
            field(TestBoolean2; TestBoolean2)
            {
                ApplicationArea = all;
                Caption = 'Test Boolean 2';
                ToolTip = 'Specifies the value of the Test Boolean 2 field.';
                trigger OnDrillDown()
                begin
                    Message('Test');
                end;
            }
        }
    }

    var
        TestBoolean1: Boolean;
        TestBoolean2: Boolean;
}
