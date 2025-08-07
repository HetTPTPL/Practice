page 60108 "Custom Workflow list"
{
    ApplicationArea = All;
    Caption = 'Custom Workflow list';
    PageType = List;
    SourceTable = "Custom Workflow Header";
    UsageCategory = Lists;
    CardPageId = "Custom Workflow Header";
    
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field.', Comment = '%';
                    ApplicationArea = all;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.', Comment = '%';
                    ApplicationArea = all;
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.', Comment = '%';
                    ApplicationArea = all;
                }
            }
        }
    }
}
