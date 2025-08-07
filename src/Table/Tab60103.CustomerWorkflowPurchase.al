table 60103 "Customer Workflow Purchase"
{
    Caption = 'Customer Workflow Purchase';
    DataClassification = ToBeClassified;
    
    fields
    {
        field(1; "Request No."; Code[20])
        {
            Caption = 'Request No.';
        }
        field(2; "Requested By"; Code[20])
        {
            Caption = 'Requested By';
        }
        field(3; "Request Date"; Date)
        {
            Caption = 'Request Date';
        }
        field(4; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item;
        }
        field(5; Quantity; Decimal)
        {
            Caption = 'Quantity';
        }
        field(6; Status; Enum Status)
        {
            Caption = 'Status';
        }
    }
    keys
    {
        key(PK; "Request No.")
        {
            Clustered = true;
        }
    }

    
}
