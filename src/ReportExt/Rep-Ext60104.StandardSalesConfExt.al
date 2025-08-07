reportextension 60104 "Standard Sales Conf. Ext" extends "Standard Sales - Order Conf."
{
    // trigger OnPreReport()
    // begin
    //     if CurrReport.TargetFormat in [ReportFormat::Pdf, ReportFormat::Xml, ReportFormat::Word] then
    //         Error('This report cannot be exported in PDF, Xml and word.');
    // end;

}
