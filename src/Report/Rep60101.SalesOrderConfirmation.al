report 60101 "Sales Order Confirmation"
{
    Caption = 'Sales Order Confirmation';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = Word;
    WordLayout = './src/Layout/SalesOrderConfirmation.docx';

    dataset
    {
        dataitem(SalesHeader; "Sales Header")
        {
            DataItemTableView = sorting("Document Type", "No.") where ("Document Type" = filter('Order'));
            RequestFilterFields = "No.";
            column(No; "No.")
            {
            }
            column(ExternalDocumentNo; "External Document No.")
            {
            }
        }
    }
    
    labels
    {
        Text001_Lbl = 'Thank you for your order. We are pleased to confirm that we have received it.';
        SO_Lbl = 'SO Number: ';
        PO_Lbl = 'PO Number: ';
        Text002_Lbl = 'Please find your order confirmation attached for your reference.';
        Text003_Lbl = 'You will receive another update as soon as your order has shipped. If you have any questions or need assistance in the meantime, feel free to contact us at ';
        Text004_Lbl = 'naops@2san.com.';
        Text005_Lbl = 'We truly appreciate your business and look forward to serving you again.';
    }
}
