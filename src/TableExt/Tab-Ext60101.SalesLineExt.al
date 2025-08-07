tableextension 60101 "Sales Line Ext" extends "Sales Line"
{
    fields
    {
        field(60100; "Description 4"; Text[100])
        {
            Caption = 'Description 4';
            DataClassification = ToBeClassified;
        }
        field(60101; "Order Date"; Date)
        {
            Caption = 'Order Date';
            DataClassification = ToBeClassified;
        }
        field(60102; Status; Enum "Sales Document Status")
        {
            Caption = 'Status';
            DataClassification = ToBeClassified;
        }
    }
}

