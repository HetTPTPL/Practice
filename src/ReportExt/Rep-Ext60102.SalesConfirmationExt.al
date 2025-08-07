reportextension 60102 "Sales - Confirmation Ext" extends "Standard Sales - Order Conf."
{
    dataset
    {
        add(Header)
        {
            column(CustPicture; CustTenantMedia.Content)
            {
            }

        }
        add(Line)
        {
            column(ItemPic; ItemTenantMedia.Content)
            {
            }
        }

        modify(Header)
        {
            trigger OnAfterAfterGetRecord()
            var
                CustomerRec: Record Customer;
            begin
                if CustomerRec.Get("Sell-to Customer No.") then
                    if CustomerRec.Image.HasValue then begin
                        CustTenantMedia.Get(CustomerRec.Image.MediaId);
                        CustTenantMedia.CalcFields(Content);
                    end;
            end;
        }
        modify(Line)
        {
            trigger OnAfterAfterGetRecord()
            var
                ItemRec: Record Item;
            begin
                if Type = Type::Item then
                    if ItemRec.Get("No.") then
                        if ItemRec.Picture.Count > 0 then begin
                            ItemTenantMedia.Get(ItemRec.Picture.Item(1));
                            ItemTenantMedia.CalcFields(Content);
                        end;
            end;
        }
    }

    rendering
    {
        layout(Docx)
        {
            Type = Word;
            LayoutFile = './src/Layout/StandardSalesOrderConf.docx';
        }
    }
    var
        CustTenantMedia: Record "Tenant Media";
        ItemTenantMedia: Record "Tenant Media";
}
