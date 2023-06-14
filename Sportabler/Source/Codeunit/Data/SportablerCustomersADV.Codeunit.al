codeunit 1000003 "Sportabler Customers ADV"
{

    procedure Import(UserId: Text; var Customer: Record Customer): Boolean
    var
        Data: JsonToken;
    begin
        if Exists(UserId, Customer) then exit(true);
        if not DownloadUser(UserId, Data) then exit(false);
        if not WriteUser(Data, Customer) then exit(false);
        exit(true);
    end;

    procedure DownloadUser(UserId: Text; var Data: JsonToken): Boolean
    begin
        if not SportablerApiConnection.AblerSingle('https://www.abler.io/rest-api/users?userId=' + userId, '', Data) then exit(false);
        exit(true);
    end;

    procedure Exists(UserId: Text; var Customer: Record Customer): Boolean
    var
        CustomerRec: Record Customer;
    begin
        CustomerRec.SetFilter(CustomerRec."Sportabler User Id ADV", UserId);

        if CustomerRec.FindFirst() then begin
            Customer := CustomerRec;
            exit(true);
        end;
        exit(false);
    end;

    procedure WriteUser(Data: JsonToken; var Customer: Record Customer): Boolean
    var
        PostCode: Record "Post Code";

        SportablerSettingsRec: Record "Sportabler Settings ADV";
        SportablerSettings: Codeunit "Sportabler Settings ADV";

        Ssn: Text;
        Name: Text;
        Address: Text;
        Post: Text;
        Phone: Text;
        Email: Text;
        UserId: Text;
    begin
        SportablerData.JsonToText(Data.AsObject(), 'ssn', Ssn);
        SportablerData.JsonToText(Data.AsObject(), 'displayName', Name);
        SportablerData.JsonToText(Data.AsObject(), 'address', Address);
        SportablerData.JsonToText(Data.AsObject(), 'postalCode', Post);
        SportablerData.JsonToText(Data.AsObject(), 'phoneNumber', Phone);
        SportablerData.JsonToText(Data.AsObject(), 'email', Email);
        SportablerData.JsonToText(Data.AsObject(), 'userId', UserId);

        if not SportablerSettings.GetSettings(SportablerSettingsRec) then exit(false);

        Customer.Init();
        PostCode.SetFilter(Code, CopyStr(Post, 1, 20));
        if PostCode.FindFirst() then begin
            Customer."Post Code" := PostCode.Code;
            Customer.City := PostCode.City;
            Customer.County := PostCode.County;
            Customer."Country/Region Code" := PostCode."Country/Region Code";
        end;



        SportablerSettings.GetNextSportablerCustomerNo(Customer."No.");
        Customer."Customer Posting Group" := SportablerSettingsRec."Customer Posting Group ADV";
        Customer."Gen. Bus. Posting Group" := SportablerSettingsRec."Gen. Bus. Posting Group ADV";
        Customer."ADV Registration No." := CopyStr(Ssn, 1, 20);
        Customer."Name" := CopyStr(Name, 1, 100);
        Customer."Address" := CopyStr(Address, 1, 100);
        Customer."Mobile Phone No." := CopyStr(Phone, 1, 30);
        Customer."E-Mail" := CopyStr(Email, 1, 80);
        Customer."Sportabler User Id ADV" := CopyStr(userId, 1, 100);
        Customer."Sportabler Customer ADV" := true;
        if not Customer.Insert() then exit(false);

        exit(true);
    end;

    var
        SportablerApiConnection: Codeunit "Sportabler API Connection ADV";
        SportablerData: Codeunit "Sportabler Data ADV";
}