pageextension 60108 "Workflow Templates Ext" extends "Workflow Templates"
{
    actions
    {
        addlast(Processing)
        {
            action(InsertAttendanceWorkflow)
            {
                ApplicationArea = All;
                Caption = 'Insert Attendance Workflow Template';
                trigger OnAction()
                var
                    WorkflowSetupExt: Codeunit "Workflow Setup Ext";
                begin
                    WorkflowSetupExt.InsertALWorkflowTemplate();
                end;
            }
        }
    }

}
