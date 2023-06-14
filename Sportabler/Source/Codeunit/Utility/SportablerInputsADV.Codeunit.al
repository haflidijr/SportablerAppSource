codeunit 1000012 "Sportabler Inputs ADV"
{
    procedure SelectAccounts()
    var
        SportablerAccountsRec: Record "Sportabler Accounts ADV";
        SportablerAccounts: Page "Sportabler Accounts ADV";
    begin

        SportablerAccountsRec.SetFilter(SportablerAccountsRec."Key Id ADV", '<> RECEIVABLE_CUSTOMER');
        Clear(SportablerAccounts);
        SportablerAccounts.SetTableView(SportablerAccountsRec);
        SportablerAccounts.SetRecord(SportablerAccountsRec);
        SportablerAccounts.LookupMode(true);
        SportablerAccounts.RunModal();
    end;

    procedure ShowAccountStatus(var red: Text): Text
    var
        SportablerAccounts: Record "Sportabler Accounts ADV";
    begin
        red := 'Unfavorable';
        if SportablerAccounts.Count() = 0 then exit('NOT CONNECTED');
        SportablerAccounts.SetFilter(SportablerAccounts."Key Id ADV", '<> RECEIVABLE_CUSTOMER');
        SportablerAccounts.SetFilter(SportablerAccounts."Account ADV", '');
        if not (SportablerAccounts.Count() = 0) then exit('SETUP NOW');
        red := 'Standard';
        exit('Accounts successfully connect!');
    end;

    procedure SelectDivision(var name: text; var ids: list of [Text])
    var
        SportablerDivisionsRec: Record "Sportabler Divisions ADV";
        SportablerDivisions: Codeunit "Sportabler Divisions ADV";
        SportablerDivisionsPage: page "Sportabler Divisions ADV";
    begin
        SportablerDivisionsPage.LookupMode(true);
        if SportablerDivisionsPage.RunModal() = Action::LookupOK then begin
            SportablerDivisionsPage.GetRecord(SportablerDivisionsRec);
            name := SportablerDivisionsRec."Division Name ADV";
            if SportablerDivisionsRec."Division Id ADV" = '*' then ids := SportablerDivisions.Get() else ids.Add(SportablerDivisionsRec."Division Id ADV");
        end;
    end;

    procedure SelectCustomerTemplate(var SportablerSettingsRec: Record "Sportabler Settings ADV")
    var
        CustomerTemplate: Record "Customer Templ.";
        CustomerTemplList: Page "Customer Templ. List";
    begin
        CustomerTemplList.LookupMode(true);
        if CustomerTemplList.RunModal() = Action::LookupOK then begin
            CustomerTemplList.GetRecord(CustomerTemplate);
            SportablerSettingsRec."Customer Posting Group ADV" := CustomerTemplate."VAT Bus. Posting Group";
            SportablerSettingsRec."Gen. Bus. Posting Group ADV" := CustomerTemplate."Gen. Bus. Posting Group";
            SportablerSettingsRec."Customer Template ADV" := CustomerTemplate.Code;
            SportablerSettingsRec."Gen. Prod. Posting Group ADV" := '';
            SportablerSettingsRec."VAT Prod. Posting Group ADV" := '';
            SportablerSettingsRec."Product Posting Group ADV" := '';
        end;
    end;

    procedure SelectProductPostingGroup(var SportablerSettingsRec: Record "Sportabler Settings ADV")
    var
        VATPostingSetup: Record "VAT Posting Setup";
        GenProductPostingGroup: Record "Gen. Product Posting Group";
        GenProductPostingGroupsPage: page "Gen. Product Posting Groups";
        Filters: Text;
    begin
        VATPostingSetup.SetFilter(VATPostingSetup."VAT Bus. Posting Group", SportablerSettingsRec."Customer Posting Group ADV");
        VATPostingSetup.Next();
        Filters := VATPostingSetup."VAT Prod. Posting Group";
        VATPostingSetup.Next();
        repeat
            Filters := Filters + ' | ' + VATPostingSetup."VAT Prod. Posting Group";
        until VATPostingSetup.Next() = 0;
        GenProductPostingGroup.SetFilter(GenProductPostingGroup."Def. VAT Prod. Posting Group", Filters);
        Clear(GenProductPostingGroupsPage);
        GenProductPostingGroupsPage.SetTableView(GenProductPostingGroup);
        GenProductPostingGroupsPage.SetRecord(GenProductPostingGroup);
        GenProductPostingGroupsPage.LookupMode(true);
        if GenProductPostingGroupsPage.RunModal() = Action::LookupOK then begin
            GenProductPostingGroupsPage.GetRecord(GenProductPostingGroup);
            SportablerSettingsRec."Gen. Prod. Posting Group ADV" := GenProductPostingGroup.Code;
            SportablerSettingsRec."VAT Prod. Posting Group ADV" := GenProductPostingGroup."Def. VAT Prod. Posting Group";
            SportablerSettingsRec."Product Posting Group ADV" := GenProductPostingGroup.Description;
        end;
    end;

    procedure GetAccountStatus(var red: Text): Text
    var
        SportablerAccounts: Record "Sportabler Accounts ADV";
    begin
        red := 'Unfavorable';
        if SportablerAccounts.Count() = 0 then exit('NOT CONNECTED');
        SportablerAccounts.SetFilter(SportablerAccounts."Account ADV", '');
        if not (SportablerAccounts."Key Id ADV" = '') then exit('SETUP NOW');
        red := 'Standard';
        exit('Accounts successfully connect!');
    end;
}

