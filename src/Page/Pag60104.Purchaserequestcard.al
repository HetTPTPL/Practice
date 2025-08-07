page 60104 "Purchase request card"
{
    ApplicationArea = All;
    Caption = 'Purchase request card';
    PageType = Card;
    SourceTable = "Customer Workflow Purchase";

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
                Editable = Iseditable;

                field("Request No."; Rec."Request No.")
                {
                    ToolTip = 'Specifies the value of the Request No. field.', Comment = '%';
                }
                field("Requested By"; Rec."Requested By")
                {
                    ToolTip = 'Specifies the value of the Requested By field.', Comment = '%';
                }
                field("Request Date"; Rec."Request Date")
                {
                    ToolTip = 'Specifies the value of the Request Date field.', Comment = '%';
                }
                field("Item No."; Rec."Item No.")
                {
                    ToolTip = 'Specifies the value of the Item No. field.', Comment = '%';
                }
                field(Quantity; Rec.Quantity)
                {
                    ToolTip = 'Specifies the value of the Quantity field.', Comment = '%';
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.', Comment = '%';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("Send for Approval")
            {
                ApplicationArea = all;
                Caption = 'Send for Approval';
                Image = SendTo;
                trigger OnAction()
                var
                    Confirmed: Boolean;
                begin
                    if Rec.Status = Rec.Status::"Pending Approval" then
                        Error('Already in the Pending Approval Status.');

                    if Rec.Status = Rec.Status::Rejected then
                        Error('Workflow is already Rejected.');

                    if Rec.Status = Rec.Status::Approved then
                        Error('Workflow is already Approved.');

                    Confirmed := Confirm('Are you sure want to Send for Approval?');
                    if not Confirmed then
                        exit;

                    Rec.Status := Rec.Status::"Pending Approval";
                    Rec.Modify(true);
                end;
            }

            action("Approve")
            {
                ApplicationArea = all;
                Caption = 'Approve';
                Image = SendTo;
                trigger OnAction()
                var
                    Confirmed: Boolean;
                begin
                    if Rec.Status = Rec.Status::Approved then
                        Error('Workflow is already Approved.');
                    if Rec.Status = Rec.Status::Open then
                        Error('Status is Open, Send it for the approval process.');
                    if Rec.Status = Rec.Status::Rejected then
                        Error('Workflow is already Rejected.');

                    Confirmed := Confirm('Are you sure want to Send for Approval?');
                    if Confirmed then begin
                        Rec.Status := Rec.Status::Approved;
                        Rec.Modify(true);
                    end
                    else begin
                        Rec.Status := Rec.Status::Rejected;
                        Rec.Modify(true);
                    end;

                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        Iseditable := Rec.Status <> Rec.Status::Approved;
        Iseditable := Rec.Status <> Rec.Status::Rejected;
    end;

    var
        Iseditable: Boolean;
}
