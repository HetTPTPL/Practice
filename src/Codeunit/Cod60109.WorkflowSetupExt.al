codeunit 60109 "Workflow Setup Ext"
{
    var
        WorkflowSetup: Codeunit "Workflow Setup";
        ALWorkflowCategoryTxt: Label 'AL';
        ALWorkflowCategoryDescTxt: Label 'Attendance Log';
        ALApprovalWorkflowCodeTxt: Label 'ALAW';
        ALApprovalWorkflowDescTxt: Label 'Attendance Log Approval Workflow';
        ALTypeCondTxt: Label '<?xml version = "1.0" encoding="utf-8" standalone="yes"?><ReportParameters><DataItems><DataItem name="Custom Workflow Header">%1</DataItem></DataItems></ReportParameters>';

    // 1. Add custom category
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Setup", 'OnAddWorkflowCategoriesToLibrary', '', true, true)]
    local procedure OnAddWorkflowCategoriesToLibrary()
    begin
        WorkflowSetup.InsertWorkflowCategory(ALWorkflowCategoryTxt, ALWorkflowCategoryDescTxt);
    end;

    // 2. Set up relation to Approval Entry table
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Setup", 'OnAfterInsertApprovalsTableRelations', '', true, true)]
    local procedure OnAfterInsertApprovalsTableRelations()
    var
        ApprovalEntry: Record "Approval Entry";
    begin
        WorkflowSetup.InsertTableRelation(Database::"Custom Workflow Header", 0, Database::"Approval Entry", ApprovalEntry.FieldNo("Record ID to Approve"));
    end;

    // 3. Insert template when templates are being inserted (called when BC is initialized)
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Setup", 'OnInsertWorkflowTemplates', '', true, true)]
    local procedure OnInsertWorkflowTemplates()
    begin
        InsertALWorkflowTemplate();
    end;

    // 4. Register events for Send/Cancel for Approval
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Event Handling", 'OnAddWorkflowEventsToLibrary', '', true, true)]
    local procedure OnAddWorkflowEventsToLibrary()
    var
        RecRef: RecordRef;
        WorkflowEventHandling: Codeunit "Workflow Event Handling";
    begin
        RecRef.Open(Database::"Custom Workflow Header");

        WorkflowEventHandling.AddEventToLibrary(
            'RUNWORKFLOWONSENDCUSTOMWFHEADERFORAPPROVAL',
            Database::"Custom Workflow Header",
            'Send Custom Workflow Header for Approval',
            0,
            false);

        WorkflowEventHandling.AddEventToLibrary(
            'RUNWORKFLOWONCANCELCUSTOMWFHEADERFORAPPROVAL',
            Database::"Custom Workflow Header",
            'Cancel Custom Workflow Header Approval',
            0,
            false);
    end;

    // 5. Insert the workflow template and its details
    procedure InsertALWorkflowTemplate()
    var
        Workflow: Record Workflow;
    begin
        if not Workflow.Get(ALApprovalWorkflowCodeTxt) then begin
            WorkflowSetup.InsertWorkflowTemplate(Workflow, ALApprovalWorkflowCodeTxt, ALApprovalWorkflowDescTxt, ALWorkflowCategoryTxt);
            InsertALApprovalWorkflowDetails(Workflow);
            WorkflowSetup.MarkWorkflowAsTemplate(Workflow);
        end;
    end;

    // 6. Define workflow events, conditions, and responses
    local procedure InsertALApprovalWorkflowDetails(var Workflow: Record Workflow)
    var
        StepArgument: Record "Workflow Step Argument";
        BlankDateFormula: DateFormula;
        ALRec: Record "Custom Workflow Header";
    begin
        WorkflowSetup.InitWorkflowStepArgument(
            StepArgument,
            StepArgument."Approver Type"::Approver,
            StepArgument."Approver Limit Type"::"Direct Approver",
            0, '', BlankDateFormula, true);

        WorkflowSetup.InsertDocApprovalWorkflowSteps(
            Workflow,
            BuildALTypeConditions(ALRec.Status::Open),
            'RUNWORKFLOWONSENDCUSTOMWFHEADERFORAPPROVAL',
            BuildALTypeConditions(ALRec.Status::"Pending"),
            'RUNWORKFLOWONCANCELCUSTOMWFHEADERFORAPPROVAL',
            StepArgument,
            true
        );
    end;

    // 7. Build filter conditions for workflow event triggers
    local procedure BuildALTypeConditions(Status: Enum "Custom Approval Enum"): Text
    var
        ALRec: Record "Custom Workflow Header";
    begin
        ALRec.SetRange(Status, Status);
        exit(StrSubstNo(ALTypeCondTxt, WorkflowSetup.Encode(ALRec.GetView(false))));
    end;
}
