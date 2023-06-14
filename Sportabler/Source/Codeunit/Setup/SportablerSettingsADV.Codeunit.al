codeunit 1000010 "Sportabler Settings ADV"
{

    // Returns current settings
    procedure GetSettings(var SportablerSettingsRec: Record "Sportabler Settings ADV"): Boolean
    var
        SportablerSettings: Record "Sportabler Settings ADV";
    begin
        if not SportablerSettings.FindFirst() then begin
            SportablerSettings.Init();
            SportablerSettings."No ADV" := 1;
            SportablerSettings."Next Sportabler Cust No. ADV" := 1;
            SportablerSettings."Next Sportabler Inv No. ADV" := 1;
            SportablerSettings."Mock ADV" := true;
            SportablerSettings."Last Job ADV" := CreateDateTime(19700101D, 000000T);
            SportablerSettings.Insert();
        end;
        SportablerSettingsRec := SportablerSettings;
        exit(true);
    end;

    // Check if we are running mock api
    procedure RunMock(): Boolean
    var
        SportablerSettingsRec: Record "Sportabler Settings ADV";
    begin
        if not GetSettings(SportablerSettingsRec) then exit(false);
        exit(SportablerSettingsRec."Mock ADV");
    end;

    // Get Bearer Token for sportabler
    procedure GetToken(var Token: Text): Boolean
    var
        SportablerSettingsRec: Record "Sportabler Settings ADV";
    begin
        if not GetSettings(SportablerSettingsRec) then exit(false);
        Token := SportablerSettingsRec."Sportabler Bearer Token ADV";
        exit(true);
    end;

    // Validates sportabler token
    procedure SetSportablerToken(var Cancel: Boolean; var SportablerSettingsRec: Record "Sportabler Settings ADV"): Boolean
    var
        SportablerDivisions: Codeunit "Sportabler Divisions ADV";
        SportablerTokenSetup: Page "Sportabler Token Setup ADV";
        TokenParts: List of [Text];
        NewToken: Text[512];

    begin
        if SportablerTokenSetup.RunModal() = Action::OK then begin
            NewToken := CopyStr(SportablerTokenSetup.GetToken().Trim(), 1, 512);
            TokenParts := NewToken.Split(' ');
            NewToken := CopyStr(TokenParts.Get(TokenParts.Count()), 1, 512);
            if not SportablerDivisions.Authorize(NewToken) then exit(false);
            exit(true);
        end else
            Cancel := true;
        exit(false);
    end;

    // Get next avaivable No. for customer
    procedure GetNextSportablerCustomerNo(var No: code[20]): Boolean
    var
        Customer: Record Customer;
        SportablerSettingsRec: Record "Sportabler Settings ADV";
        SportablerSettings: Codeunit "Sportabler Settings ADV";
        NextNo: Integer;
    begin
        if not SportablerSettings.GetSettings(SportablerSettingsRec) then exit(false);
        NextNo := SportablerSettingsRec."Next Sportabler Cust No. ADV";
        while Customer.Get(Format(NextNo)) do NextNo := NextNo + 1;
        SportablerSettingsRec."Next Sportabler Cust No. ADV" := NextNo + 1;
        if not SportablerSettingsRec.Modify() then exit(false);
        if StrLen(Format(NextNo)) < 7 then
            No := CopyStr('SUSER-' + PadStr('', 6 - StrLen(Format(NextNo)), '0') + Format(NextNo), 1, 20)
        else
            No := CopyStr('SUSER-' + Format(NextNo), 0, 20);
        exit(true);
    end;

    // Get next avaivable No. for invoice
    procedure GetNextSportablerInvoiceNo(var No: code[20]): Boolean
    var
        SalesHeader: Record "Sales Header";
        SportablerSettingsRec: Record "Sportabler Settings ADV";
        SportablerSettings: Codeunit "Sportabler Settings ADV";
        NextNo: Integer;
    begin

        if not SportablerSettings.GetSettings(SportablerSettingsRec) then exit(false);
        NextNo := SportablerSettingsRec."Next Sportabler Inv No. ADV";
        while SalesHeader.Get(Format(NextNo)) do NextNo := NextNo + 1;
        SportablerSettingsRec."Next Sportabler Inv No. ADV" := NextNo + 1;
        if not SportablerSettingsRec.Modify() then exit(false);
        if StrLen(Format(NextNo)) < 7 then
            No := CopyStr('SINV-' + PadStr('', 6 - StrLen(Format(NextNo)), '0') + Format(NextNo), 1, 20)
        else
            No := CopyStr('SINV-' + Format(NextNo), 0, 20);
        exit(true);
    end;


    // Get next avaivable No. for item
    procedure GetNextSportablerItemNo(var No: code[20]): Boolean
    var
        Item: Record Item;
        SportablerSettingsRec: Record "Sportabler Settings ADV";
        SportablerSettings: Codeunit "Sportabler Settings ADV";
        NextNo: Integer;
    begin

        if not SportablerSettings.GetSettings(SportablerSettingsRec) then exit(false);
        NextNo := SportablerSettingsRec."Next Sportabler Item No. ADV";
        while Item.Get(Format(NextNo)) do NextNo := NextNo + 1;
        SportablerSettingsRec."Next Sportabler Item No. ADV" := NextNo + 1;
        if not SportablerSettingsRec.Modify() then exit(false);
        if StrLen(Format(NextNo)) < 7 then
            No := CopyStr('SITEM-' + PadStr('', 6 - StrLen(Format(NextNo)), '0') + Format(NextNo), 1, 20)
        else
            No := CopyStr('SITEM-' + Format(NextNo), 0, 20);
        exit(true);
    end;

    // Get datetime when we last gathered data
    procedure GetLastTime(next: Datetime; var last: Datetime): Boolean
    var
        SportablerSettingsRec: Record "Sportabler Settings ADV";
        SportablerSettings: Codeunit "Sportabler Settings ADV";
    begin
        if not SportablerSettings.GetSettings(SportablerSettingsRec) then exit(false);
        last := SportablerSettingsRec."Last Job ADV";
        SportablerSettingsRec."Last Job ADV" := next;
        if not SportablerSettingsRec.Modify() then exit(false);
        exit(true);
    end;
}
