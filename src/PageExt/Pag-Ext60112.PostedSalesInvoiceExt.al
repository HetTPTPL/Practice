pageextension 60112 "Posted Sales Invoice Ext" extends "Posted Sales Invoice"
{
    layout
    {

        addlast(FactBoxes)
        {
            part(CustomFactBox; "Sales Invoice Factbox")
            {
                ApplicationArea = All;
                SubPageLink = "No." = FIELD("No.");
            }
        }
    }
}
