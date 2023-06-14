codeunit 1000001 "Sportabler Import ADV"
{
    trigger OnRun()
    var
        SportablerSettingsRec: Record "Sportabler Settings ADV";
        SportablerSettings: Codeunit "Sportabler Settings ADV";
        SportablerEvents: Codeunit "Sportabler Events ADV";
        SportablerData: Codeunit "Sportabler Data ADV";
        SportablerDivisions: Codeunit "Sportabler Divisions ADV";
        CurrentTime: DateTime;
    begin
        if not SportablerSettings.GetSettings(SportablerSettingsRec) then Error('Sportabler settings not found.');
        CurrentTime := CurrentDateTime();
        if SportablerEvents.Import(SportablerData.ListToString(SportablerDivisions.Get()), SportablerData.FormatDateTime(SportablerSettingsRec."Last Job ADV"), SportablerData.FormatDateTime(CurrentTime)) then begin
            SportablerSettingsRec."Last Job ADV" := CurrentTime;
            SportablerSettingsRec.Modify();
        end;
    end;
}
