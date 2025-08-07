reportextension 60103 "Standard Sales Order Conf Ext" extends "Standard Sales - Order Conf."
{
    requestpage
    {
        trigger OnOpenPage()
        begin
            LogInteraction := true;
            ArchiveDocument := true;
            DisplayAssemblyInformation := true;
        end;
    }
}
