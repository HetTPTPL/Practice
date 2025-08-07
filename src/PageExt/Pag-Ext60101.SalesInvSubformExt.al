pageextension 60101 "Sales Inv. Subform Ext" extends "Sales Invoice Subform"
{
    layout
    {
        addafter(Description)
        {
            field("Description 4"; Rec."Description 4")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Description 4 field.', Comment = '%';
            }
        }
    }      
}
