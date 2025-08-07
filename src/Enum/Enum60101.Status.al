enum 60101 Status
{
    Extensible = true;
    
    value(0; "")
    {
        Caption = ' ';
    }
    value(1; Open)
    {
        Caption = 'Open';
    }
    value(2; "Pending Approval")
    {
        Caption = 'Pending Approval';
    }
    value(3; Approved)
    {
        Caption = 'Approved';
    }
    value(4; Rejected)
    {
        Caption = 'Rejected';
    }
}
