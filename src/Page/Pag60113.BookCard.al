page 60113 "Book Card"
{
    ApplicationArea = All;
    Caption = 'Book Card';
    PageType = Card;
    SourceTable = Book;
    
    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
                
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field.', Comment = '%';
                }
                field(Title; Rec.Title)
                {
                    ToolTip = 'Specifies the value of the Title field.', Comment = '%';
                }
            }
            group(Details)
            {
                Caption = 'Details';
                
                field(Author; Rec.Author)
                {
                    ToolTip = 'Specifies the value of the Author field.', Comment = '%';
                }
                field(Hardcover; Rec.Hardcover)
                {
                    ToolTip = 'Specifies the value of the Hardcover field.', Comment = '%';
                }
            }
        }
    }

    trigger OnOpenPage()
    var
    OpenPageMsg: Label 'Developer translation for %1', Comment = '%1 is extension name', Locked = false, MaxLength = 999;
    Module: ModuleInfo;
    begin
        NavApp.GetCurrentModuleInfo(Module);
        Message(OpenPageMsg, Module.Name);
    end;
}
