codeunit 1000007 "Sportabler Invoices ADV"
{
    procedure Import(InvoiceId: Text; Category: Text; Customer: Record Customer): Boolean
    var
        SalesHeader: Record "Sales Header";

        Data: JsonToken;
    begin
        // Check if invoice already exists
        SalesHeader.SetFilter(SalesHeader."Sportabler Invoice Id ADV", InvoiceId);
        if not SalesHeader.IsEmpty() then exit(true);
        if not DownloadInvoice(InvoiceId, Data) then exit(false);
        if not WriteInvoice(Data, Category, Customer, SalesHeader) then exit(false);
        exit(true);
    end;

    // Get invoice by id from Sportabler
    local procedure DownloadInvoice(InvoiceId: Text; var Data: JsonToken): Boolean
    var
        SportablerSettingsRec: Record "Sportabler Settings ADV";
        DateFrom: Text;
        DateTo: Text;
        Url: Text;
    begin
        DateFrom := SportablerData.FormatDateTime(CreateDateTime(19700101D, 000000T));
        DateTo := SportablerData.FormatDateTime(CreateDateTime(Today(), 230000T));
        if not SportablerSettings.GetSettings(SportablerSettingsRec) then exit(false);
        Url := 'https://www.abler.io/rest-api/payments/invoices?clubId=' + Format(SportablerSettingsRec."Club Id ADV") + '&dateFrom=' + DateFrom + '&dateTo=' + DateTo + '&invoiceId=' + InvoiceId + '&first=200';
        if not SportablerApiConnection.AblerSingle(Url, '', Data) then exit(false);
        exit(true);
    end;

    local procedure WriteInvoice(Data: JsonToken; Category: Text; var Customer: Record Customer; var SalesHeader: Record "Sales Header"): Boolean
    var
        Item: Record Item;
        ItemVariant: Record "Item Variant";

        SalesLine: Record "Sales Line";

        SportablerSettingsRec: Record "Sportabler Settings ADV";
        SportablerDimensions: Codeunit "Sportabler Dimensions ADV";

        Invoice: JsonToken;
        Items: JsonArray;
        SingleItem: JsonToken;

        Id: Decimal;
        Title: Text;
        Division: Text;
        AgeGroup: Text;

        UserId: Text;
        CreadedBy: Text;

        Name: Text;
        Amount: Decimal;
        Quantity: Decimal;

        DueDateText: Text;
        DueDate: Date;

        LineCounter: Integer;
    begin
        if not SportablerSettings.GetSettings(SportablerSettingsRec) then exit(false);

        foreach Invoice in Data.AsArray() do begin
            SportablerData.JsonToDecimal(Invoice.AsObject(), 'invoiceNr', Id);
            SportablerData.JsonToText(Invoice.AsObject(), 'title', Title);
            SportablerData.JsonToText(Invoice.AsObject(), 'divisionName', Division);
            SportablerData.JsonToText(Invoice.AsObject(), 'ageGroupName', AgeGroup);
            SportablerData.JsonToText(Invoice.AsObject(), 'userId', UserId);
            SportablerData.JsonToText(Invoice.AsObject(), 'createdBy', CreadedBy);
            SportablerData.JsonToText(Invoice.AsObject(), 'dueDate', DueDateText);
            SportablerData.JsonToArray(Invoice.AsObject(), 'items', Items);

            DueDate := DT2Date(SportablerData.DateTimeFromString(DueDateText));

            // Create user
            if not SportablerCustomers.Import(UserId, Customer) then exit(false);

            // Create product
            if not SportablerProducts.Import(Invoice, Category, Item) then break;


            SportablerSettings.GetNextSportablerInvoiceNo(SalesHeader."No.");
            SalesHeader."Document Type" := SalesHeader."Document Type"::Invoice;
            SalesHeader."Posting Date" := WORKDATE();
            SalesHeader."Customer Posting Group" := SportablerSettingsRec."Customer Posting Group ADV";
            SalesHeader."Document Date" := SalesHeader."Posting Date";
            SalesHeader."Sell-to Customer No." := Customer."No.";
            SalesHeader."Sell-to Customer Name" := Customer.Name;
            SalesHeader."Sell-to Address" := Customer.Address;
            SalesHeader."Sell-to City" := Customer.City;
            SalesHeader."Sell-to Post Code" := Customer."Post Code";
            SalesHeader."Sell-to E-Mail" := Customer."E-Mail";
            SalesHeader."Sell-to Phone No." := Customer."Phone No.";
            SalesHeader."Sportabler Sales Order ADV" := true;
            SalesHeader."Bill-to Customer No." := Customer."No.";
            SalesHeader."Due Date" := DueDate;
            SalesHeader."Sportabler Invoice Id ADV" := Id;
            SalesHeader."Bill-to Country/Region Code" := Customer."Country/Region Code";
            SalesHeader."Bal. Account Type" := SalesHeader."Bal. Account Type"::"G/L Account";
            SportablerDimensions.AddSubDimension(Division, AgeGroup, SalesHeader);
            SalesHeader.Insert();

            LineCounter := 0;

            // Get all items and add them as a sales line
            foreach SingleItem in Items do begin
                SportablerData.JsonToText(SingleItem.AsObject(), 'name', Name);
                SportablerData.JsonToDecimal(SingleItem.AsObject(), 'amount', Amount);
                SportablerData.JsonToDecimal(SingleItem.AsObject(), 'quantity', Quantity);

                LineCounter := LineCounter + 1;

                ItemVariant.Get(Item."No.", CopyStr(Name, 1, 10));

                SalesLine."Line No." := LineCounter;

                SalesLine."Document Type" := SalesHeader."Document Type";
                SalesLine."Document No." := SalesHeader."No.";
                SalesLine.Type := SalesLine.Type::Item;

                SalesLine."Gen. Bus. Posting Group" := SportablerSettingsRec."Gen. Bus. Posting Group ADV";
                SalesLine."VAT Prod. Posting Group" := SportablerSettingsRec."VAT Prod. Posting Group ADV";

                SalesLine."No." := Item."No.";
                SalesLine."Variant Code" := CopyStr(Name, 1, 10);

                SalesLine.Description := ItemVariant.Description;
                SalesLine.Quantity := Quantity;
                SalesLine."Unit Price" := Amount;
                SalesLine."Quantity (Base)" := Quantity;
                SalesLine."Qty. to Invoice" := Quantity;
                SalesLine."Qty. to Invoice (Base)" := Quantity;
                SalesLine."VAT Calculation Type" := SalesLine."VAT Calculation Type"::"Normal VAT";
                SalesLine."Line Amount" := Amount;
                SalesLine.Amount := Amount;
                SalesLine."Amount Including VAT" := Amount;
                SalesLine."Inv. Discount Amount" := 0;
                SalesLine."Qty. to Ship" := Quantity;

                SalesLine."Unit of Measure Code" := Item."Base Unit of Measure";
                SalesLine."Gen. Bus. Posting Group" := Customer."Gen. Bus. Posting Group";
                SalesLine."Gen. Prod. Posting Group" := Item."Gen. Prod. Posting Group";
                SalesLine.Insert();

            end;
        end;
        exit(true);
    end;


    var
        SportablerApiConnection: Codeunit "Sportabler API Connection ADV";
        SportablerData: Codeunit "Sportabler Data ADV";
        SportablerCustomers: Codeunit "Sportabler Customers ADV";
        SportablerSettings: Codeunit "Sportabler Settings ADV";
        SportablerProducts: Codeunit "Sportabler Products ADV";
}


// 2e911206-e350-42a8-9a5c-e1253854ff0b