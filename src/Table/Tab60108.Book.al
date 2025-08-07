table 60108 Book
{
    Caption = 'Book';
    DataClassification = ToBeClassified;
    
    fields
    {
        field(1; "No."; Code[10])
        {
            Caption = 'No.';
        }
        field(2; Title; Text[50])
        {
            Caption = 'Title';
        }
        field(3; Author; Text[50])
        {
            Caption = 'Author';
        }
        field(4; Hardcover; Boolean)
        {
            Caption = 'Hardcover';
        }
    }
    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
    }
}
