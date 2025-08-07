reportextension 60100 "Standard Sales - Pro Inv Ext" extends "Standard Sales - Pro Forma Inv"
{
    dataset
    {
        add(Header)
        {
            column(CompanyInfo_BankAccountNo; CompanyInfo."Bank Account No.")
            {
            }
            column(CompanyInfo_BankName; CompanyInfo."Bank Name")
            {
            }
            column(CompanyInfo_BankBranchNo; CompanyInfo."Bank Branch No.")
            {
            }
            column(CompanyInfo_GiroNo; CompanyInfo."Giro No.")
            {
            }
            column(CompanyInfo_SWIFTCode; CompanyInfo."SWIFT Code")
            {
            }
        }
        add(line)
        {
            column(SrNo; SrNo)
            {

            }
        }
        modify(Line)
        {

            trigger OnAfterPreDataItem()
            begin
                SrNo := 0;
            end;

            trigger OnBeforeAfterGetRecord()
            begin
                SrNo += 1;
            end;

        }
    }

    rendering
    {
        layout("StandardSalesProFormaInv.rdlc")
        {
            Type = RDLC;
            LayoutFile = './src/Layout/StandardSalesProFormaInv.rdl';
        }
    }

    trigger OnPreReport()
    begin
        CompanyInfo.Get();
    end;

    var
        CompanyInfo: Record "Company Information";
        SrNo: Integer;
}
