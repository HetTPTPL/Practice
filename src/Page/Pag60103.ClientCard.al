page 60103 "Client Card"
{
    ApplicationArea = All;
    Caption = 'Client Card';
    PageType = Card;
    SourceTable = Client;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
                field("Number Series"; Rec."Number Series")
                {
                    ToolTip = 'Specifies the value of the Number Series field.', Comment = '%';
                }
                field("Client Code"; Rec."Client Code")
                {
                    ToolTip = 'Specifies the value of the Client Code field.', Comment = '%';
                    Caption = 'Client Code';
                    ShowMandatory = true;
                }

                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the value of the Name field.', Comment = '%';
                    Caption = 'Name';
                    InstructionalText = 'Please Enter a Client Name';
                }
                field(City; Rec.City)
                {
                    ToolTip = 'Specifies the value of the City field.', Comment = '%';
                    AssistEdit = true;

                    trigger OnAssistEdit()
                    var
                        PostCodePage: Page "Post Codes";
                        PostCodeRec: Record "Post Code";
                        FilteredPostCode: Text;
                    begin
                        PostCodePage.LookupMode(true);
                        if PostCodePage.RunModal() = ACTION::LookupOK then begin
                            PostCodePage.SetSelectionFilter(PostCodeRec);
                            if PostCodeRec.FindSet() then
                                repeat
                                    if FilteredPostCode <> '' then
                                        FilteredPostCode += '|';
                                    FilteredPostCode += PostCodeRec.Code;
                                until PostCodeRec.Next() = 0;
                            Rec.City := FilteredPostCode;
                        end;
                    end;
                }
                field("Client's Customer"; Rec."Client's Customer")
                {
                    ToolTip = 'Specifies the value of the Client''s Customer field.', Comment = '%';
                    Caption = 'Client''s Customer';
                    // Lookup = true;
                    // LookupPageId = "Customer List";
                }
                field("Client's Vendor"; Rec."Client's Vendor")
                {
                    ToolTip = 'Specifies the value of the Client''s Vendor field.', Comment = '%';
                    Caption = 'Client''s Vendor';
                }
                field("Sales Amount"; Rec."Sales Amount")
                {
                    ToolTip = 'Specifies the value of the Sales Amount field.', Comment = '%';
                    Caption = 'Sales Amount';
                }
                field("Purchase Amount"; Rec."Purchase Amount")
                {
                    ToolTip = 'Specifies the value of the Purchase Amount field.', Comment = '%';
                    Caption = 'Purchase Amount';
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ToolTip = 'Specifies the value of the Posting Date field.', Comment = '%';
                    Caption = 'Posting Date';
                }
                field(WorkDescription; WorkDescriptionText)
                {
                    Caption = 'Work Description';
                    MultiLine = true;
                    Editable = true;
                    ToolTip = 'Specifies the products or service being offered.';

                    trigger OnValidate()
                    begin
                        SetWorkDescription(WorkDescriptionText);
                    end;
                }
            }
        }
    }
    var
        WorkDescriptionText: Text;

    trigger OnAfterGetRecord()
    begin
        WorkDescriptionText := GetWorkDescription();
    end;

    procedure GetWorkDescription(): Text
    var
        InS: InStream;
        TextData: Text;
    begin
        Rec.CalcFields("Work Description");
        Rec."Work Description".CreateInStream(InS, TEXTENCODING::UTF8);
        InS.ReadText(TextData);
        // end;
        exit(TextData);
    end;

    procedure SetWorkDescription(NewWorkDescription: Text)
    var
        OutStream: OutStream;
    begin
        // OnBeforeSetWorkDescription(Rec, NewWorkDescription);
        Clear(Rec."Work Description");
        Rec."Work Description".CreateOutStream(OutStream, TEXTENCODING::Windows);
        OutStream.WriteText(NewWorkDescription);
        Rec.Modify(true);
    end;
}
