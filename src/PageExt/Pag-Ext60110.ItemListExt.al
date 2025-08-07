pageextension 60110 "Item List Ext" extends "Item List"
{
    actions
    {
        addlast(processing)
        {
            action(FindDuplicate)
            {
                Caption = 'Find Duplicates';
                ApplicationArea = all;
                Image = FilterLines;

                trigger OnAction()
                var
                    Item01: Record Item;
                    Item02: Record Item;
                    ItemDescription: Text[100];
                    DuplicateFilter: Text[2048];
                begin
                    DuplicateFilter := '';
                    ItemDescription := '';
                    Item01.Reset();
                    Item01.SetCurrentKey(Description);
                    Item01.Ascending(true);
                    if Item01.FindSet() then
                        repeat
                            if ItemDescription <> Item01.Description then begin
                                Item02.Reset();
                                Item02.SetRange(Description, Item01.Description);
                                if Item02.Count > 1 then begin
                                    ItemDescription := Item01.Description;
                                    if DuplicateFilter = '' then
                                        DuplicateFilter := Item01.Description
                                    else
                                        DuplicateFilter := DuplicateFilter + '|' + Item01.Description;
                                end;
                            end;
                        until Item01.Next() = 0;
                    Message(DuplicateFilter);
                    Rec.SetFilter(Description, DuplicateFilter);
                    CurrPage.Update();
                end;
            }
        }
        addlast(Promoted)
        {
            actionref(FindDuplicate_promoted; FindDuplicate)
            {
            }
        }
    }
}
