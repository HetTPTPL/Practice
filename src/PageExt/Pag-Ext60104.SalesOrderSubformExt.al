pageextension 60104 "Sales Order Subform Ext" extends "Sales Order Subform"
{
    layout
    {
        addafter("Item Reference No.")
        {
            field("Order Date"; Rec."Order Date")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Order Date field.';
            }
            field(Status; Rec.Status)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Status field.', Comment = '%';
            }
        }
    }
}
