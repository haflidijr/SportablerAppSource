codeunit 1000008 "Sportabler Products ADV"
{
    procedure Import(Data: JsonToken; Category: Text; var Item: Record Item): Boolean
    var
        ItemRec: Record Item;
        ItemVariant: Record "Item Variant";
        ItemCategory: Record "Item Category";
        UnitofMeasure: Record "Unit of Measure";
        SportablerSettingsRec: Record "Sportabler Settings ADV";
        VATSetupPostingGroups: Record "VAT Setup Posting Groups";
        PriceListLine: Record "Price List Line";

        SportablerSettings: Codeunit "Sportabler Settings ADV";
        SportablerData: Codeunit "Sportabler Data ADV";

        Title: Text;
        Division: Text;
        AgeGroup: Text;

        Name: Text;
        Amount: Decimal;

        Items: JsonArray;
        SingleItem: JsonToken;

    begin
        SportablerData.JsonToText(Data.AsObject(), 'title', Title);
        SportablerData.JsonToText(Data.AsObject(), 'divisionName', Division);
        SportablerData.JsonToText(Data.AsObject(), 'ageGroupName', AgeGroup);
        SportablerData.JsonToArray(Data.AsObject(), 'items', Items);

        // Check if item exists
        ItemRec.SetFilter(Description, Title);
        if ItemRec.FindFirst() then begin
            Item := ItemRec;
            exit(true);
        end;

        // Create category if it doesn't exists
        if not ItemCategory.Get(Category) then
            if not CreateCategory(Category, LowerCase(Category), ItemCategory) then exit(false);

        // Set unit of mesure from Advania 365 extensions
        if not UnitofMeasure.Get('EIN') then exit(false);

        // Get settings
        if not SportablerSettings.GetSettings(SportablerSettingsRec) then exit(false);

        // Create Item
        Item.Init();
        SportablerSettings.GetNextSportablerItemNo(Item."No.");
        Item.Description := CopyStr(Title, 1, 100);
        Item."Gen. Prod. Posting Group" := SportablerSettingsRec."Gen. Prod. Posting Group ADV";
        Item.Type := Item.Type::Service;
        Item."Sportabler Item ADV" := true;
        Item."Item Category Code" := ItemCategory.Code;
        Item."Base Unit of Measure" := UnitofMeasure.Code;
        Item."Unit Price" := 1;
        Item."VAT Prod. Posting Group" := SportablerSettingsRec."VAT Prod. Posting Group ADV";
        Item."Sales Unit of Measure" := UnitofMeasure.Code;
        Item."Variant Mandatory if Exists" := Item."Variant Mandatory if Exists"::Yes;
        Item."Minimum Order Quantity" := 1;
        Item.Insert();

        VATSetupPostingGroups.PopulateVATProdGroups();

        // Create item variants
        foreach SingleItem in Items do begin
            SportablerData.JsonToText(SingleItem.AsObject(), 'name', Name);
            SportablerData.JsonToDecimal(SingleItem.AsObject(), 'amount', Amount);
            if Amount = 0 then break;
            if not ItemVariant.Get(Item."No.", CopyStr(Name, 1, 10)) then begin
                ItemVariant.Init();
                ItemVariant."Item No." := Item."No.";
                ItemVariant.Code := CopyStr(Name, 1, 10);
                ItemVariant.Description := CopyStr(Title + ', ' + Name, 1, 100);
                ItemVariant.Insert();
            end;
            PriceListLine.SetFilter("Variant Code", CopyStr(Name, 1, 10));
            if not (PriceListLine."Variant Code" = Name) and (PriceListLine."Price List Code" = Item."No.") then begin
                PriceListLine.Init();
                PriceListLine."Variant Code" := CopyStr(Name, 1, 10);
                PriceListLine."Price List Code" := 'CUSTOMER';
                PriceListLine.Description := CopyStr(Title + ', ' + Name, 1, 100);
                PriceListLine."Minimum Quantity" := 1;
                PriceListLine."Unit Price" := Amount;
                PriceListLine."Price List Code" := Item."No.";
                PriceListLine.Insert();
            end;
        end;
        exit(true);
    end;

    // Create category
    procedure CreateCategory(Name: Text; Description: Text; var ItemCategory: Record "Item Category"): Boolean
    var
        ParentItemCategory: Record "Item Category";
    begin
        if not ParentItemCategory.Get('SPORTABLER') then begin
            ParentItemCategory.Init();
            ParentItemCategory.Code := 'SPORTABLER';
            ParentItemCategory.Description := 'Sportabler Categories';
            ParentItemCategory.Insert();
        end;
        if not ItemCategory.Get(Name) then begin
            ItemCategory.Init();
            ItemCategory."Parent Category" := ParentItemCategory.Code;
            ItemCategory.Code := CopyStr(Name, 1, 20);
            ItemCategory.Description := CopyStr(Description, 1, 100);
            ItemCategory.Insert();
        end;
        exit(true);
    end;
}
