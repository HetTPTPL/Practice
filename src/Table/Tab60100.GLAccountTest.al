table 60100 "G/L Account Test"
{
    Caption = 'G/L Account Test';
    DataClassification = ToBeClassified;
    
    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
        }
        field(2; Name; Text[100])
        {
            Caption = 'Name';
        }
        field(3; "Net Change"; Decimal)
        {
            Caption = 'Net Change';
        }
        field(4; Balance; Decimal)
        {
            Caption = 'Balance';
        }
    }
    keys
    {
        key(PK; "Code")
        {
            Clustered = true;
        }
    }
}
