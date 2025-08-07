pageextension 60111 "Sales Order List Ext" extends "Sales Order List"
{
    actions
    {
        modify("Print Confirmation")
        {
            trigger OnBeforeAction()
            var
                MyDialog: Dialog;
                MyNext: Integer;
                Text000: Label 'Redirecting to the Sales - Confirmation Report in #1 Seconds.';
            begin
                MyNext := 11;
                MyDialog.Open(Text000, MyNext);
                repeat
                    Sleep(1000);
                    MyNext := MyNext - 1;
                    MyDialog.Update();
                until MyNext = 1;
                MyDialog.Close();
            end;
        }
    }
}
