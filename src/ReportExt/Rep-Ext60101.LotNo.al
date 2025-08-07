reportextension 60101 "Lot No" extends "Lot No Label"
{
    dataset
    {
        add("Lot No. Information")
        {
            column(Certificate_Number; "Certificate Number")
            {
            }
            column(Test_Quality; "Test Quality")
            {
            }
            column(CustomLotNoBarcode; CustomLotNoBarcode)
            {
            }
            column(CustomLotNoQRCode; CustomLotNoQRCode)
            {
            }
        }

        modify("Lot No. Information")
        {
            RequestFilterFields = "Certificate Number";
            trigger OnAfterAfterGetRecord()
            var
                Item: Record "Item";
                BarcodeString: Text;
                BarcodeFontProvider: Interface "Barcode Font Provider";
                BarcodeFontProvider2D: Interface "Barcode Font Provider 2D";
                BarcodeSymbology: Enum "Barcode Symbology";
                BarcodeSymbology2D: Enum "Barcode Symbology 2D";
                LotNoCode: Text;
                LotNoQRCode: Text;
            begin
                // Initialize symbologies!
                // BarcodeSymbology := Enum::"Barcode Symbology"::Code39;
                // BarcodeSymbology2D := Enum::"Barcode Symbology 2D"::"QR-Code";

                // BarcodeFontProvider := Enum::"Barcode Font Provider"::IDAutomation1D;
                // BarcodeFontProvider2D := Enum::"Barcode Font Provider 2D"::IDAutomation2D;

                // Item.SetLoadFields(Item.Description);
                // Item.Get("Item No.");
                // Description := Item.Description;

                // // Set data string source
                // if ("Lot No." <> '') and ("Certificate Number" <> '') then begin
                //     BarcodeString := StrSubstNo('%1 %2', "Lot No.", "Certificate Number");
                //     // Validate the input
                //     BarcodeFontProvider.ValidateInput(BarcodeString, BarcodeSymbology);
                //     // Encode the data string to the barcode font
                //     CustomLotNoBarcode := BarcodeFontProvider.EncodeFont(BarcodeString, BarcodeSymbology);
                //     CustomLotNoQRCode := BarcodeFontProvider2D.EncodeFont(BarcodeString, BarcodeSymbology2D);
                // end;
                BarcodeSymbology2D := Enum::"Barcode Symbology 2D"::"QR-Code";
                BarcodeFontProvider2D := Enum::"Barcode Font Provider 2D"::IDAutomation2D;

                Item.SetLoadFields(Item.Description);
                Item.Get("Item No.");
                Description := Item.Description;

                if ("Lot No." <> '') and ("Certificate Number" <> '') then begin
                    BarcodeString := StrSubstNo('%1,%2', "Lot No.", "Certificate Number");

                    CustomLotNoQRCode := BarcodeFontProvider2D.EncodeFont(BarcodeString, BarcodeSymbology2D);
                end;
            end;
        }
    }

    requestpage
    {
        
    }


    rendering
    {
        layout(Word)
        {
            Type = Word;
            LayoutFile = './src/Layout/Word.docx';
        }
    }

    var
        CustomLotNoBarcode: Text;
        CustomLotNoQRCode: Text;

}
