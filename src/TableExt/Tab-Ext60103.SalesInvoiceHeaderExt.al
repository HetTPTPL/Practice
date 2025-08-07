tableextension 60103 "Sales Invoice Header Ext" extends "Sales Invoice Header"
{
    fields
    {
        field(60100; "Custom Blob"; Media)
        {
            Caption = 'Custom Blob';
            DataClassification = ToBeClassified;
            // Subtype = Bitmap;
        }
    }
}
