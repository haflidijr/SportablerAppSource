codeunit 1000005 "Sportabler Divisions ADV"
{

    // Update divisions
    procedure Import(): Boolean
    begin
        exit(Authorize(''));
    end;

    // Authorize token and get divisions
    procedure Authorize(AuthToken: Text): Boolean
    var
        Data: JsonToken;
    begin
        if not DownloadDivisions(AuthToken, Data) then exit(false);
        if not CreateDivisions(AuthToken, Data) then exit(false);
        exit(true);
    end;

    // Get divisions from Sportabler
    procedure DownloadDivisions(AuthToken: Text; var Data: JsonToken): Boolean
    begin
        if not SportablerApiConnection.AblerSingle('https://www.abler.io/rest-api/divisions', AuthToken, Data) then exit(false);
        exit(true);
    end;

    // Create divisions in BC
    procedure CreateDivisions(AuthToken: Text; Data: JsonToken): Boolean
    var
        SportablerSettingsRec: Record "Sportabler Settings ADV";
        SportablerSettings: Codeunit "Sportabler Settings ADV";

        Division: JsonToken;

        Id: Text;
        Name: Text;
        ClubId: Text;
    begin
        if not SportablerSettings.GetSettings(SportablerSettingsRec) then exit(false);

        if not Data.IsArray() then exit(false);
        foreach Division in Data.AsArray() do begin
            if not SportablerData.JsonToText(Division.AsObject(), 'id', Id) then break;
            if not SportablerData.JsonToText(Division.AsObject(), 'name', Name) then break;
            if not SportablerData.JsonToText(Division.AsObject(), 'clubId', ClubId) then break;
            if not WriteDivision(Id, Name, ClubId) then break;
        end;
        SportablerSettingsRec."Club Id ADV" := CopyStr(ClubId, 1, 2048);
        if AuthToken <> '' then SportablerSettingsRec."Sportabler Bearer Token ADV" := CopyStr(AuthToken, 1, 512);
        if not SportablerSettingsRec.Modify() then exit(false);
        exit(true);
    end;

    // Write division to table
    procedure WriteDivision(Id: Text; Name: Text; ClubId: Text): Boolean
    var
        SportablerDivisions: Record "Sportabler Divisions ADV";
    begin
        if SportablerDivisions.Count() = 0 then begin
            SportablerDivisions.Init();
            SportablerDivisions."Club Id ADV" := '*';
            SportablerDivisions."Division Id ADV" := '*';
            SportablerDivisions."Division Name ADV" := 'All';
            SportablerDivisions.Insert();
        end;
        // Check if division exists or is empty
        if Id = '' then exit(false);
        if SportablerDivisions.Get(Id) then exit(true);

        // Create new division
        SportablerDivisions.Init();
        SportablerDivisions."Division Id ADV" := CopyStr(Id, 1, 20);
        SportablerDivisions."Division Name ADV" := CopyStr(Name, 1, 100);
        SportablerDivisions."Club Id ADV" := CopyStr(ClubId, 1, 20);
        if not SportablerDivisions.Insert() then exit(false);
        exit(true);
    end;

    // Get list of division from BC
    procedure Get(): List of [Text]
    var
        SportablerDivisions: Record "Sportabler Divisions ADV";
        Divisions: List of [Text];
        Division: Text;
    begin
        SportablerDivisions.FindSet();
        SportablerDivisions.Next();
        repeat
            Division := SportablerDivisions."Division Id ADV";
            if not (Division = '*') then
                Divisions.Add(Division);
        until SportablerDivisions.Next() = 0;
        exit(Divisions)
    end;


    var
        SportablerApiConnection: Codeunit "Sportabler API Connection ADV";
        SportablerData: Codeunit "Sportabler Data ADV";
}
