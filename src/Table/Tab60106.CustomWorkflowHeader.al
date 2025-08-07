table 60106 "Custom Workflow Header"
{
    Caption = 'Custom Workflow Header';
    DataClassification = ToBeClassified;
    DrillDownPageId = "Custom Workflow list";
    LookupPageId = "Custom Workflow list";
    fields
    {
        field(1; "No."; Code[10])
        {
            Caption = 'No.';
            DataClassification = ToBeClassified;
        }
        field(2; Description; Text[100])
        {
            Caption = 'Description';
            DataClassification = ToBeClassified;
        }
        field(3; Status; Enum "Custom Approval Enum")
        {
            Caption = 'Status';
            DataClassification = ToBeClassified;
            Editable = false;
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
