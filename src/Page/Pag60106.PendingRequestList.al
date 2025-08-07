page 60106 "Pending Request List"
{
    ApplicationArea = All;
    Caption = 'Pending Request List';
    PageType = List;
    SourceTable = "Pending Request";
    UsageCategory = Lists;
    
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Request Id"; Rec."Request Id")
                {
                    ToolTip = 'Specifies the value of the Request Id field.', Comment = '%';
                }
                field("Requested Amount"; Rec."Requested Amount")
                {
                    ToolTip = 'Specifies the value of the Requested Amount field.', Comment = '%';
                }
                field(Currency; Rec.Currency)
                {
                    ToolTip = 'Specifies the value of the Currency field.', Comment = '%';
                }
                field("Requested Date"; Rec."Requested Date")
                {
                    ToolTip = 'Specifies the value of the Requested Date field.', Comment = '%';
                }
                field("Last Update Date"; Rec."Last Update Date")
                {
                    ToolTip = 'Specifies the value of the Last Update Date field.', Comment = '%';
                }
                field(CoverId; Rec.CoverId)
                {
                    ToolTip = 'Specifies the value of the CoverId field.', Comment = '%';
                }
            }
        }
    }
}
