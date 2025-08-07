pageextension 60106 "Document Attachment Detail Ext" extends "Document Attachment Details"
{
    actions
    {
        addfirst(processing)
        {
            action(PreviewWord)
            {
                ApplicationArea = all;
                Caption = 'Preview Word';
                ToolTip = 'Executes the Preview Word action.';
                Image = View;

                trigger OnAction()
                var
                    DocAttach: Record "Document Attachment";
                    InStr: InStream;
                    OutStr: OutStream;
                    TempBlobCU: Codeunit "Temp Blob";
                    DocumentReportMgtCU: Codeunit "Document Report Mgt.";
                    FileName: Text;
                begin
                    DocAttach.Reset();
                    CurrPage.SetSelectionFilter(DocAttach);
                    if DocAttach.FindFirst() then
                        if DocAttach."Document Reference ID".HasValue then begin
                            TempBlobCU.CreateOutStream(OutStr);
                            DocAttach."Document Reference ID".ExportStream(OutStr);
                            DocumentReportMgtCU.ConvertWordToPdf(TempBlobCU, 0);
                            TempBlobCU.CreateInStream(InStr);
                            FileName := Format(DocAttach."File Name" + '.pdf');
                            File.ViewFromStream(InStr, FileName + '.' + 'pdf', true);
                        end;
                end;
            }
            action(BulkDownload)
            {
                Caption = 'Bulk Download';
                ApplicationArea = All;
                
                trigger OnAction()
                var
                    TempBlob: Codeunit "Temp Blob";
                    FileManagement: Codeunit "File Management";
                    DocumentOutStream: OutStream;
                    DocumentInStream: InStream;
                    ZipOutStream: OutStream;
                    ZipInStream: InStream;
                    FullFileName: Text;
                    DataCompression: Codeunit "Data Compression";
                    ZipFileName: Text[50];
                    DocumentAttachment: Record "Document Attachment";
                begin
                    ZipFileName := 'Attachments_' + Format(CurrentDateTime) + '.zip';
                    DataCompression.CreateZipArchive();
                    DocumentAttachment.Reset();
                    CurrPage.SetSelectionFilter(DocumentAttachment);
                    if DocumentAttachment.FindSet() then
                        repeat
                            if DocumentAttachment."Document Reference ID".HasValue then begin
                                TempBlob.CreateOutStream(DocumentOutStream);
                                DocumentAttachment."Document Reference ID".ExportStream(DocumentOutStream);
                                TempBlob.CreateInStream(DocumentInStream);
                                FullFileName := DocumentAttachment."File Name" + '.' + DocumentAttachment."File Extension";
                                DataCompression.AddEntry(DocumentInStream, FullFileName);
                            end;
                        until DocumentAttachment.Next() = 0;
                    TempBlob.CreateOutStream(ZipOutStream);
                    DataCompression.SaveZipArchive(ZipOutStream);
                    TempBlob.CreateInStream(ZipInStream);
                    DownloadFromStream(ZipInStream, '', '', '', ZipFileName);
                end;
            }
        }

        addafter(Preview_Promoted)
        {
            actionref(PreviewWord_promoted; PreviewWord)
            {
            }
            actionref(BulkDownload_promoted; BulkDownload)
            {
            }
        }
    }
}
