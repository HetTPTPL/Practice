table 60104 "Pending Request"
{
    Caption = 'Pending Request';
    DataClassification = ToBeClassified;
    TableType = Temporary;
    
    fields
    {
        field(1; "Request Id"; Code[30])
        {
            Caption = 'Request Id';
        }
        field(2; "Requested Amount"; Decimal)
        {
            Caption = 'Requested Amount';
        }
        field(3; Currency; Code[10])
        {
            Caption = 'Currency';
        }
        field(4; "Requested Date"; Date)
        {
            Caption = 'Requested Date';
        }
        field(5; "Last Update Date"; Date)
        {
            Caption = 'Last Update Date';
        }
        field(6; CoverId; Text[100])
        {
            Caption = 'CoverId';
        }
    }
    keys
    {
        key(PK; "Request Id")
        {
            Clustered = true;
        }
    }
}
