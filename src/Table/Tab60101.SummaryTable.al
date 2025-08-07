table 60101 "Summary Table"
{
    Caption = 'Summary Table';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';

            trigger OnValidate()
            var
                CustomerRec: Record Customer;
                VendorRec: Record Vendor;
                ItemRec: Record Item;
                GLAccountRec: Record "G/L Account";
                FixedAssetRec: Record "Fixed Asset";
            begin
                if Type = Type::Customer then begin
                    if CustomerRec.Get("No.") then
                        Name := CustomerRec.Name;
                end else if Type = Type::Vendor then begin
                    if VendorRec.get("No.") then
                        Name := VendorRec.Name;
                end else if Type = Type::Item then begin
                    if ItemRec.Get("No.") then
                        Name := ItemRec.Description;
                end else if Type = Type::"G/L Account" then begin
                    if GLAccountRec.Get("No.") then
                        Name := GLAccountRec.Name;
                end else if Type = Type::"Fixed Asset" then begin
                    if FixedAssetRec.Get("No.") then
                        Name := FixedAssetRec.Description;
                end;
            end;
        }
        field(2; "Type"; Enum Type)
        {
            Caption = 'Type';          
        }
        field(3; Name; Text[100])
        {
            Caption = 'Name';
        }
        field(4; "Sales Total"; Decimal)
        {
            Caption = 'Sales Total';
        }
        field(5; "Purchase Total"; Decimal)
        {
            Caption = 'Purchase Total';
        }
        field(6; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
    }
    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }
}
