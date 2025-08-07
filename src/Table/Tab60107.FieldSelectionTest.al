table 60107 "Field Selection Test"
{
    Caption = 'Field Selection Test';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Table No."; Integer)
        {
            Caption = 'Table No.';
        }
        field(2; "Table Name"; Text[50])
        {
            Caption = 'Table Name';
        }
        field(3; "Field No."; Integer)
        {
            Caption = 'Field No.';
        }
        field(4; "Field Name"; Text[30])
        {
            Caption = 'Field Name';
        }
    }
    keys
    {
        key(PK; "Table No.")
        {
            Clustered = true;
        }
    }
}
