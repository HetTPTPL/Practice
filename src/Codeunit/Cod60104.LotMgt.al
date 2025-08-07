codeunit 60104 "Lot Mgt."
{
    [EventSubscriber(ObjectType::Table, Database::"Lot No. Information", OnBeforeValidateEvent, 'Lot No.', false, false)]
    local procedure MyProcedure(var Rec: Record "Lot No. Information")
    var
        CommaPos: Integer;
        LotNo: Text[50];
        CertificateNo: Text[20];
    begin
        CommaPos := StrPos(Rec."Lot No.", ',');
        if CommaPos > 0 then begin
            LotNo := CopyStr(Rec."Lot No.", 1, CommaPos - 1);
            CertificateNo := CopyStr(Rec."Lot No.", CommaPos + 1);

            Rec."Lot No." := LotNo;
            Rec."Certificate Number" := CertificateNo;
        end;
    end;
}
