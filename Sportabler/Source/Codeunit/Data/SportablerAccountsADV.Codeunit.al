codeunit 1000002 "Sportabler Accounts ADV"
{

    // Update divisions
    procedure Import(): Boolean
    var
        Data: JsonToken;
    begin
        if not DownloadAccounts(Data) then exit(false);
        if not CreateAccounts(Data) then exit(false);
        exit(true);
    end;

    // Get chart of accounts from Sportabler
    procedure DownloadAccounts(var Data: JsonToken): Boolean
    var
    begin
        if not SportablerApiConnection.AblerSingle('https://www.abler.io/accounting/config/chart-of-accounts', '', Data) then exit(false);
        exit(true);
    end;

    // Create divisions in BC
    procedure CreateAccounts(Data: JsonToken): Boolean
    var
        Account: JsonToken;

        Id: Text;
        Name: Text;
    begin
        if not Data.IsArray() then exit(false);
        foreach Account in Data.AsArray() do begin
            if not SportablerData.JsonToText(Account.AsObject(), 'keyId', Id) then break;
            if not SportablerData.JsonToText(Account.AsObject(), 'name', Name) then break;
            if not WriteAccount(Id, Name) then break;
        end;
        exit(true);
    end;

    // Write division to table
    procedure WriteAccount(Id: Text; Name: Text): Boolean
    var
        SportablerAccounts: Record "Sportabler Accounts ADV";
    begin
        // Check if division exists or is empty
        if Id = '' then exit(false);
        if SportablerAccounts.Get(Id) then exit(false);

        // Create new account
        SportablerAccounts.Init();
        SportablerAccounts."Key Id ADV" := CopyStr(Id, 1, 100);
        SportablerAccounts."Name ADV" := CopyStr(Name, 1, 300);
        SportablerAccounts."Account ADV" := CopyStr(GetBCAccount(Id), 1, 20);
        if not SportablerAccounts.Insert() then exit(false);
        exit(true);
    end;

    procedure GetBCAccount(Id: Text): Text
    begin
        if Id = 'BANK_ACCOUNT' then exit('42320');
        if Id = 'CASH_ACCOUNT' then exit('42310');
        if Id = 'EXPENSES_DISCOUNT' then exit('6910');
        if Id = 'EXPENSES_MERCHANT_OPERATIONAL' then exit('27820');
        if Id = 'FUTURE_INCOME' then exit('42615');
        if Id = 'INCOME' then exit('10150');
        if Id = 'INCOME_GM_INTEREST' then exit('42140');
        if Id = 'RECEIVABLE_COACH' then exit('42160');
        if Id = 'RECEIVABLE_CUSTOMER' then exit('*');
        if Id = 'RECEIVABLE_MERCHANT' then exit('42150');
        exit('');
    end;

    procedure GetAccount(KeyId: Text): Code[20]
    var
        SportablerAccounts: Record "Sportabler Accounts ADV";
    begin
        if SportablerAccounts.Get(KeyId) then exit(SportablerAccounts."Account ADV");
        exit('');
    end;

    var
        SportablerApiConnection: Codeunit "Sportabler API Connection ADV";
        SportablerData: Codeunit "Sportabler Data ADV";
}
