pageextension 60102 "Payment Journal Ext" extends "Payment Journal"
{
    actions
    {
        addafter("&Line")
        {
            action("Go to Acc.")
            {
                ApplicationArea = all;
                Caption = 'Go to Acc.';
                ToolTip = 'Go to Acc.';
                Image = View;
                trigger OnAction()
                var
                    CustomerRec: Record Customer;
                    VendorRec: Record Vendor;
                    EmployeeRec: Record Employee;
                    GlAccountRec: Record "G/L Account";
                    BankAccountRec: Record "Bank Account";
                    FixedAssetRec: Record "Fixed Asset";
                    ICPartnerRec: Record "IC Partner";
                    AllocationAccountRec: Record "Allocation Account";
                begin
                    case Rec."Account Type" of
                        Rec."Account Type"::Customer:
                            if CustomerRec.Get(Rec."Account No.") then
                                Page.Run(Page::"Customer Card", CustomerRec);

                        Rec."Account Type"::Vendor:
                            if VendorRec.Get(Rec."Account No.") then
                                Page.Run(Page::"Vendor Card", VendorRec);

                        Rec."Account Type"::Employee:
                            if EmployeeRec.Get(Rec."Account No.") then
                                Page.Run(Page::"Employee Card", EmployeeRec);
                        
                        Rec."Account Type"::"Bank Account":
                            if BankAccountRec.Get(Rec."Account No.") then
                                Page.Run(Page::"Bank Account Card", BankAccountRec);

                        Rec."Account Type"::"Fixed Asset":
                            if FixedAssetRec.Get(Rec."Account No.") then
                                Page.Run(Page::"Fixed Asset Card", FixedAssetRec);

                        Rec."Account Type"::"Allocation Account":
                            if AllocationAccountRec.Get(Rec."Account No.") then
                                Page.Run(Page::"Allocation Account", AllocationAccountRec);

                        Rec."Account Type"::"G/L Account":
                            if GlAccountRec.Get(Rec."Account No.") then
                                Page.Run(Page::"G/L Account Card", GlAccountRec);

                        Rec."Account Type"::"IC Partner":
                            if ICPartnerRec.Get(Rec."Account No.") then
                                Page.Run(Page::"IC Partner Card", ICPartnerRec);
                    end;
                end;
            }
        }
    }
}
