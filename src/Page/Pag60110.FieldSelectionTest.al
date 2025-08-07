page 60110 "Field Selection Test"
{
    ApplicationArea = All;
    Caption = 'Field Selection Test';
    PageType = List;
    SourceTable = "Field Selection Test";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Table No."; Rec."Table No.")
                {
                    ToolTip = 'Specifies the value of the Table No. field.', Comment = '%';
                    ApplicationArea = all;
                    TableRelation = Field.TableNo;
                    trigger OnValidate()
                    var
                        FieldRec: Record Field;
                    begin
                        FieldRec.SetRange(TableNo, Rec."Table No.");
                        if FieldRec.FindFirst() then
                            Rec."Table Name" := FieldRec.TableName;
                    end;
                }
                field("Table Name"; Rec."Table Name")
                {
                    ToolTip = 'Specifies the value of the Table Name field.', Comment = '%';
                    ApplicationArea = all;
                }
                field("Field No."; Rec."Field No.")
                {
                    ToolTip = 'Specifies the value of the Field No. field.', Comment = '%';
                    ApplicationArea = all;
                    trigger OnLookup(var Text: Text): Boolean
                    var
                        FieldSelctn: Codeunit "Field Selection";
                        FieldRec: Record Field;
                    begin
                        FieldRec.SetRange(TableNo, Rec."Table No.");
                        FieldRec.FindSet();
                        FieldSelctn.Open(FieldRec);
                        Rec."Field No." := FieldRec."No.";
                        Rec."Field Name" := FieldRec.FieldName;
                    end;
                }
                field("Field Name"; Rec."Field Name")
                {
                    ToolTip = 'Specifies the value of the Field Name field.', Comment = '%';
                    ApplicationArea = all;
                }
            }
        }
    }
}
