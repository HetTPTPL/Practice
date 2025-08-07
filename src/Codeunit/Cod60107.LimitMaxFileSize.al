codeunit 60107 "Limit Max File Size"
{
    [EventSubscriber(ObjectType::Table, Database::"Document Attachment", 'OnBeforeSaveAttachment', '', false, false)]
    local procedure OnBeforeSaveAttachment(var TempBlob: Codeunit "Temp Blob");
    var
        Msg: Label 'The number of bytes is %1';
    begin
        Message(Msg, TempBlob.Length());
    end;

    [EventSubscriber(ObjectType::Table, Database::"Document Attachment", 'OnBeforeSaveAttachment', '', false, false)]
    local procedure DocumentAttachmentOnBeforeSaveAttachment(var TempBlob: Codeunit "Temp Blob");
    var
        Msg: Label 'The attachment exceeds 1 MB and cannot be uploaded. The current size is %1 MB.';
    begin
        if TempBlob.Length() > 1 * 1024 * 1024 then
            Error(Msg, Round(TempBlob.Length() / 1024 / 1024, 0.01, '='));
    end;
}