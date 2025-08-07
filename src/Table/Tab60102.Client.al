table 60102 Client
{
    Caption = 'Client';
    DataClassification = ToBeClassified;
    DataPerCompany = false;
    DataCaptionFields = "Client Code", Name;

    fields
    {
        field(1; "Client Code"; Code[20])
        {
            Caption = 'Client Code';

        }
        field(2; Name; Text[100])
        {
            Caption = 'Name';

        }
        field(3; "Client's Customer"; Text[100])
        {
            Caption = 'Client''s Customer';
            TableRelation = Customer where(Blocked = filter(" "));
        }
        field(4; "Client's Vendor"; Text[100])
        {
            Caption = 'Client''s Vendor';
            TableRelation = Vendor where(Blocked = filter(" "));
        }
        field(5; "Sales Amount"; Decimal)
        {
            Caption = 'Sales Amount';
            FieldClass = FlowField;
            CalcFormula = sum("Sales Invoice Line".Amount where("Sell-to Customer No." = field("Client's Customer"), "Posting Date" = field("Posting Date")));
            Editable = false;
        }
        field(6; "Purchase Amount"; Decimal)
        {
            Caption = 'Purchase Amount';
            FieldClass = FlowField;
            CalcFormula = sum("Purch. Inv. Line".Amount where("Buy-from Vendor No." = field("Client's Vendor"), "Posting Date" = field("Posting Date")));
            Editable = false;
        }
        field(7; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(8; "Work Description"; Blob)
        {
            Caption = 'Work Description';
            Subtype = Memo;
        }
        field(9; "Number Series"; Code[20])
        {
            Caption = 'Number Series';
            TableRelation = "No. Series";
        }
        field(10; City; Text[30])
        {
            Caption = 'City';
            // TableRelation = "Post Code".Code;
        }
        

    }
    keys
    {
        key(PK; "Client Code")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    var
        NumberSeries: Codeunit "No. Series";
        NewNo: Code[20];
    begin
        if "Client Code" = '' then
            if "Number Series" <> '' then begin
                NewNo := NumberSeries.GetNextNo("Number Series", WorkDate(), true);
                "Client Code" := NewNo;
            end
            else
                Error('Number Series is not Assigned');
    end;


}
