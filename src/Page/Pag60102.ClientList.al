page 60102 "Client List"
{
    ApplicationArea = All;
    Caption = 'Client List';
    PageType = List;
    SourceTable = Client;
    UsageCategory = Lists;
    CardPageId = "Client Card";


    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Client Code"; Rec."Client Code")
                {
                    ToolTip = 'Specifies the value of the Client Code field.', Comment = '%';
                }
                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the value of the Name field.', Comment = '%';
                }
                field("Client's Customer"; Rec."Client's Customer")
                {
                    ToolTip = 'Specifies the value of the Client''s Customer field.', Comment = '%';
                }
                field("Client's Vendor"; Rec."Client's Vendor")
                {
                    ToolTip = 'Specifies the value of the Client''s Vendor field.', Comment = '%';
                }
                field("Sales Amount"; Rec."Sales Amount")
                {
                    ToolTip = 'Specifies the value of the Sales Amount field.', Comment = '%';
                }
                field("Purchase Amount"; Rec."Purchase Amount")
                {
                    ToolTip = 'Specifies the value of the Purchase Amount field.', Comment = '%';
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ToolTip = 'Specifies the value of the Posting Date field.', Comment = '%';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Pending Requests")
            {
                ApplicationArea = All;
                Caption = 'Pending Requests';
                Image = View;

                trigger OnAction()
                var
                    API_lCU: Codeunit "API Mgt.";
                begin
                    API_lCU.PendingRequest();
                end;
            }
        }
    }
}
