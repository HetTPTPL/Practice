page 60112 "Book List"
{
    ApplicationArea = All;
    Caption = 'Book List';
    PageType = List;
    SourceTable = Book;
    UsageCategory = Lists;
    CardPageId = "Book Card";
    
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
                field(Title; Rec.Title)
                {
                    ToolTip = 'Specifies the value of the Title field.', Comment = '%';
                    ApplicationArea = all;
                }
                field(Author; Rec.Author)
                {
                    ToolTip = 'Specifies the value of the Author field.', Comment = '%';
                    ApplicationArea = all;
                }
                field(Hardcover; Rec.Hardcover)
                {
                    ToolTip = 'Specifies the value of the Hardcover field.', Comment = '%';
                    ApplicationArea = all;
                }
            }
        }
    }
}
