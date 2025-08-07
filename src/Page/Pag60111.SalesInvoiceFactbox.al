page 60111 "Sales Invoice Factbox"
{
    ApplicationArea = All;
    Caption = 'Sales Invoice Factbox';
    PageType = CardPart;
    SourceTable = "Sales Invoice Header";

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
                field("Custom Blob"; Rec."Custom Blob")
                {
                    ApplicationArea = All;
                    ToolTip = 'Shows the custom blob field.';
                }
            }
        }
    }
}
