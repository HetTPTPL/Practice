pageextension 60103 "Chart of Accounts Ext" extends "Chart of Accounts"
{
    actions
    {
        addlast("A&ccount")
        {
            action("Insert to Test")
            {
                ApplicationArea = all;
                Caption = 'Insert to Test';
                ToolTip = 'Insert to Test';
                Image = Insert;
                trigger OnAction()
                var
                    GLAccountTestRec: Record "G/L Account Test";
                    GLAccountRec: Record "G/L Account";
                begin
                    CurrPage.SetSelectionFilter(GLAccountRec);

                    if GLAccountRec.FindSet() then
                        repeat
                            GLAccountRec.CalcFields("Net Change", Balance);

                            if GLAccountTestRec.Get(GLAccountRec."No.") then
                                GLAccountTestRec.Delete();

                            GLAccountTestRec.Init();
                            GLAccountTestRec.Code := GLAccountRec."No.";
                            GLAccountTestRec.Name := GLAccountRec.Name;
                            GLAccountTestRec."Net Change" := GLAccountRec."Net Change";
                            GLAccountTestRec.Balance := GLAccountRec.Balance;
                            GLAccountTestRec.Insert();
                        until GLAccountRec.Next() = 0;

                    Page.Run(Page::"G/L Account Test", GLAccountTestRec);
                end;
            }
        }
    }

    trigger OnOpenPage()
    var
        Text000: Label 'Account 100';
    begin
        Message(IncStr(Text000));
    end;
}
