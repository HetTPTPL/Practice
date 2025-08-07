page 60101 "Summary Worksheet"
{
    ApplicationArea = All;
    Caption = 'Summary Worksheet';
    PageType = Worksheet;
    SourceTable = "Summary Table";
    UsageCategory = Tasks;

    layout
    {
        area(Content)
        {
            group(Filters)
            {
                field(TypeFilter; TypeFilter)
                {
                    Caption = 'Type Filter';
                    ToolTip = 'Type Filter';

                    trigger OnValidate()
                    begin
                        NoFilter := '';
                    end;
                }
                field(NoFilter; NoFilter)
                {
                    Caption = 'No. Filter';
                    ToolTip = 'No. Filter';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        CustomerRec: Record Customer;
                        VendorRec: Record Vendor;
                        ItemRec: Record Item;
                        GLAccountRec: Record "G/L Account";
                        FixedAssetRec: Record "Fixed Asset";
                    begin
                        if TypeFilter = TypeFilter::" " then begin
                            Message('Please select the No Filter.');
                            exit(true);
                        end;

                        case TypeFilter of
                            TypeFilter::Customer:
                                if Page.RunModal(Page::"Customer List", CustomerRec) = Action::LookupOK then begin
                                    Text := CustomerRec."No.";
                                    exit(true);
                                end;

                            TypeFilter::"Fixed Asset":
                                if Page.RunModal(Page::"Fixed Asset List", FixedAssetRec) = Action::LookupOK then begin
                                    Text := FixedAssetRec."No.";
                                    exit(true);
                                end;

                            TypeFilter::"G/L Account":
                                if Page.RunModal(Page::"G/L Account List", GLAccountRec) = Action::LookupOK then begin
                                    Text := GLAccountRec."No.";
                                    exit(true);
                                end;

                            TypeFilter::Item:
                                if Page.RunModal(Page::"Item List", ItemRec) = Action::LookupOK then begin
                                    Text := ItemRec."No.";
                                    exit(true);
                                end;

                            TypeFilter::Vendor:
                                if Page.RunModal(Page::"Vendor List", VendorRec) = Action::LookupOK then begin
                                    Text := VendorRec."No.";
                                    exit(true);
                                end;

                            else
                                Message('Please select the valid type filter before choosing the No. Filter');

                        end;

                        exit(false);
                    end;
                }

            }
            repeater(General)
            {
                Editable = false;
                field("Type"; Rec."Type")
                {
                    ToolTip = 'Specifies the value of the Type field.', Comment = '%';
                }
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field.', Comment = '%';
                }
                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the value of the Name field.', Comment = '%';
                }
                field("Sales Total"; Rec."Sales Total")
                {
                    ToolTip = 'Specifies the value of the Sales Total field.', Comment = '%';
                    trigger OnDrillDown()
                    var
                        SummaryMgt: Codeunit "Summary Mgt.";
                    begin
                        SummaryMgt.DrillDownSales(Rec.Type, Rec."No.");
                    end;
                }
                field("Purchase Total"; Rec."Purchase Total")
                {
                    ToolTip = 'Specifies the value of the Purchase Total field.', Comment = '%';
                    trigger OnDrillDown()
                    var
                        SummaryMgt: Codeunit "Summary Mgt.";
                    begin
                        SummaryMgt.DrillDownPurchase(Rec.Type, Rec."No.");
                    end;
                }
                field("Entry No."; Rec."Entry No.")
                {
                    ToolTip = 'Specifies the value of the Entry No. field.', Comment = '%';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Insert)
            {
                ApplicationArea = all;
                Caption = 'Insert';
                Image = Insert;
                trigger OnAction()
                var
                    SummaryCU: Codeunit "Summary Mgt.";
                begin
                    SummaryCU.CheckRecExist(TypeFilter, NoFilter);
                    CurrPage.Update();
                end;
            }
            action(Delete)
            {
                ApplicationArea = all;
                Caption = 'Delete';
                Image = Delete;
                trigger OnAction()
                begin
                    if Confirm('Are you sure you want to delete this record?') then
                        Rec.Delete();
                end;
            }
            action("Show Record")
            {
                ApplicationArea = All;
                Caption = 'Show Record';
                Image = ShowSelected;
                trigger OnAction()
                begin
                    Rec.Reset();
                    Rec.SetRange(Type, TypeFilter);
                    Rec.SetRange("No.", NoFilter);
                end;
            }
            action("Show All Record")
            {
                ApplicationArea = all;
                Caption = 'Show All Record';
                ToolTip = 'Show All Record';
                Image = ShowList;
                trigger OnAction()
                begin
                    Rec.Reset();
                    CurrPage.Update(false);
                end;
            }
        }
        area(Promoted)
        {
            actionref(ShowAllRecord_Promoted; "Show All Record")
            {
            }
            actionref(Insert_Promoted; Insert)
            {
            }
            actionref(Delete_Promoted; Delete)
            {
            }
            actionref(ShowRecord_Promoted; "Show Record")
            {
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.FilterGroup(2);
        Rec.SetRange("No.", '');
        Rec.FilterGroup(0);
    end;

    var
        TypeFilter: Enum Type;
        NoFilter: Code[20];
}
