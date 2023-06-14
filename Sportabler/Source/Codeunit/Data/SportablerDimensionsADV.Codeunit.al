codeunit 1000004 "Sportabler Dimensions ADV"
{
    trigger OnRun()
    begin
        Import();
    end;

    procedure Import(): Boolean
    var
        Data: JsonToken;
    begin
        if not DownloadDimensions(Data) then exit(false);
        if not CreateDimensions(Data) then exit(false);
        exit(true);
    end;

    // Add sub dimension to dimension
    procedure AddSubDimension(Division: Text; AgeGroup: Text; var SalesHeader: Record "Sales Header"): Boolean
    var
        TempDimensionSetEntry: Record "Dimension Set Entry" temporary;
        TempDimensionSetEntry2: Record "Dimension Set Entry" temporary;

        DefaultDimension: Record "Default Dimension";
        DimensionValue: Record "Dimension Value";

        SportablerSettingsRec: Record "Sportabler Settings ADV";
        SportablerSettings: Codeunit "Sportabler Settings ADV";

        DimensionManagement: Codeunit DimensionManagement;
    begin

        if not SportablerSettings.GetSettings(SportablerSettingsRec) then exit(false);

        if not DimensionValue.Get('SDIV', Division) or not DimensionValue.Get('SSUB', AgeGroup) then Import();

        // Make set of dimensions to add to sales header
        TempDimensionSetEntry.Init();
        TempDimensionSetEntry.Validate("Dimension Code", 'SDIV');
        TempDimensionSetEntry.Validate("Dimension Value Code", Division);
        TempDimensionSetEntry.Insert();

        if not DimensionValue.Get('SSUB', AgeGroup) then begin
            DimensionValue.Init();
            DimensionValue."Dimension Code" := 'SSUB';
            DimensionValue.Code := CopyStr(AgeGroup, 1, 20);
            DimensionValue.Insert();

            DefaultDimension.Init();
            DefaultDimension."No." := CopyStr(AgeGroup, 1, 20);
            DefaultDimension."Dimension Code" := 'SSUB';
            DefaultDimension."Dimension Value Code" := CopyStr(AgeGroup, 1, 20);
            DefaultDimension.Insert();
        end;

        TempDimensionSetEntry.Init();
        TempDimensionSetEntry.Validate("Dimension Code", 'SSUB');
        TempDimensionSetEntry.Validate("Dimension Value Code", AgeGroup);
        TempDimensionSetEntry.Insert();

        DimensionManagement.GetDimensionSet(TempDimensionSetEntry2, SalesHeader."Dimension Set ID");
        if TempDimensionSetEntry.FindSet() then
            repeat
                if TempDimensionSetEntry2.Get(SalesHeader."Dimension Set ID", TempDimensionSetEntry."Dimension Code") then begin
                    TempDimensionSetEntry2.Validate("Dimension Value Code", TempDimensionSetEntry."Dimension Value Code");
                    TempDimensionSetEntry2.Modify();
                end else begin
                    TempDimensionSetEntry2 := TempDimensionSetEntry;
                    TempDimensionSetEntry2."Dimension Set ID" := SalesHeader."Dimension Set ID";
                    TempDimensionSetEntry2.Insert();
                end;
            until TempDimensionSetEntry.Next() = 0;

        SalesHeader."Dimension Set ID" := DimensionManagement.GetDimensionSetID(TempDimensionSetEntry);
        DimensionManagement.UpdateGlobalDimFromDimSetID(SalesHeader."Dimension Set ID", SalesHeader."Shortcut Dimension 1 Code", SalesHeader."Shortcut Dimension 2 Code");
        exit(true);
    end;

    // Get chart of dimensions from Sportabler
    procedure DownloadDimensions(var Data: JsonToken): Boolean
    var
        SportablerSettingsRec: Record "Sportabler Settings ADV";
        SportablerSettings: Codeunit "Sportabler Settings ADV";
    begin
        if not SportablerSettings.GetSettings(SportablerSettingsRec) then exit(false);
        if not SportablerApiConnection.AblerSingle('https://www.abler.io/accounting/context/' + SportablerSettingsRec."Club Id ADV" + '?projection=TREE', '', Data) then exit(false);
        exit(true);
    end;

    // Create dimensions in BC
    procedure CreateDimensions(Data: JsonToken): Boolean
    var
        Dimension: Record Dimension;
        DimensionValue: Record "Dimension Value";
        DefaultDimension: Record "Default Dimension";

        Childs: JsonObject;
        Divisions: JsonArray;
        Division: JsonToken;

        Description: Text;
        Id: Decimal;
    begin
        if not Dimension.Get('SDIV') then begin
            Dimension.Init();
            Dimension.Code := 'SDIV';
            Dimension.Name := 'Divisions';
            Dimension.Insert();
        end;
        if not Dimension.Get('SSUB') then begin
            Dimension.Init();
            Dimension.Code := 'SSUB';
            Dimension.Name := 'Sub-division of division';
            Dimension.Insert();
        end;

        if not SportablerData.JsontoObject(Data.AsObject(), 'children', Childs) then exit(false);
        if not SportablerData.JsonToArray(Childs, 'DIVISION', Divisions) then exit(false);

        foreach Division in Divisions do begin

            SportablerData.JsonToText(Division.AsObject(), 'description', Description);
            SportablerData.JsonToDecimal(Division.AsObject(), 'id', Id);

            if not DimensionValue.Get('SDIV', CopyStr(Description, 1, 20)) then begin
                DimensionValue.Init();
                DimensionValue."Dimension Code" := 'SDIV';
                DimensionValue.Name := CopyStr(Description, 1, 50);
                DimensionValue.Code := CopyStr(Description, 1, 20);
                DimensionValue.Insert();
            end;

            DefaultDimension.SetFilter("Dimension Value Code", CopyStr(Description, 1, 20));

            if not DefaultDimension.FindFirst() then begin
                DefaultDimension.Init();
                DefaultDimension."No." := CopyStr(Description, 1, 20);
                DefaultDimension."Dimension Code" := 'SDIV';
                DefaultDimension."Dimension Value Code" := CopyStr(Description, 1, 20);
                DefaultDimension.Insert();
            end;
        end;
        exit(true);
    end;

    var
        SportablerApiConnection: Codeunit "Sportabler API Connection ADV";
        SportablerData: Codeunit "Sportabler Data ADV";
}
