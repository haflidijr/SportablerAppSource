codeunit 1000009 "Sportabler Transactions ADV"
{
    procedure Import(Transaction: JsonObject; PostDate: Date; UserId: Text): Boolean
    var
        GenJournalLine: Record "Gen. Journal Line";
        GenJournalTemplate: Record "Gen. Journal Template";
        GenJournalBatches: Record "Gen. Journal Batch";
        NoSeries: Record "No. Series";
        NoSeriesLine: Record "No. Series Line";
        GenJournalDocumentType: Enum "Gen. Journal Document Type";

        DebitType: Enum "Gen. Journal Account Type";
        DebitNo: Code[20];
        CreditType: Enum "Gen. Journal Account Type";
        CreditNo: Code[20];
        Amount: Decimal;
    begin

        if not GenJournalTemplate.Get('ALMENNT') then exit(false);

        if not NoSeries.Get('ST') then begin
            NoSeries.Code := 'ST';
            NoSeries.Description := 'Sportabler transactions';
            NoSeries."Default Nos." := true;
            NoSeries."Manual Nos." := true;
            NoSeries.Insert();
        end;

        if not GenJournalBatches.Get(GenJournalTemplate.Name, 'SPORTABLER') then begin
            GenJournalBatches.Init();
            GenJournalBatches.Name := 'SPORTABLER';
            GenJournalBatches."Journal Template Name" := GenJournalTemplate.Name;
            GenJournalBatches."Bal. Account Type" := GenJournalBatches."Bal. Account Type"::"G/L Account";
            GenJournalBatches.Description := 'Sportabler transactions';
            GenJournalBatches."No. Series" := NoSeries.Code;
            GenJournalBatches."Posting No. Series" := 'ST';
            GenJournalBatches.Insert();
        end;

        NoSeriesLine.SetFilter("Series Code", NoSeries.Code);
        if not NoSeriesLine.FindFirst() then begin
            NoSeriesLine.Init();
            NoSeriesLine."Series Code" := 'ST';
            NoSeriesLine."Increment-by No." := 1;
            NoSeriesLine."Allow Gaps in Nos." := true;
            NoSeriesLine."Starting No." := 'ST00000';
            NoSeriesLine."Sequence Name" := 'ST';
            NoSeriesLine.Insert();
        end;

        ReadTransaction(Transaction, UserId, DebitType, DebitNo, CreditType, CreditNo, Amount);

        GenJournalLine.Init();
        GenJournalLine."Posting No. Series" := NoSeries.Code;
        GenJournalLine."Journal Template Name" := GenJournalTemplate.Name;
        GenJournalLine."Journal Batch Name" := GenJournalBatches.Name;
        GenJournalLine."Document No." := NoSeriesLine.GetNextSequenceNo(true);
        GenJournalLine."Line No." := GenJournalLine.count + 1;
        GenJournalLine.Validate("Posting Date", PostDate);
        GenJournalLine.Validate("Document Type", GenJournalDocumentType::" ");
        GenJournalLine."Account Type" := DebitType;
        GenJournalLine.Validate("Account No.", CopyStr(DebitNo, 1, 20));
        GenJournalLine.Validate(Amount, Amount);
        GenJournalLine."Bal. Account Type" := CreditType;
        GenJournalLine."Bal. Account No." := CopyStr(CreditNo, 1, 20);
        GenJournalLine.Insert();

        exit(true);
    end;


    procedure ReadTransaction(
        Transaction: JsonObject;
        UserId: Text;
        var DebitType: Enum "Gen. Journal Account Type";
        var DebitNo: Code[20];
        var CreditType: Enum "Gen. Journal Account Type";
        var CreditNo: Code[20];
        var Amount: Decimal
        ): Boolean
    var
        Customer: Record Customer;

        DebitKey: Text;
        CreditKey: Text;
    begin
        SportablerData.JsonToText(Transaction, 'debitKey', DebitKey);
        SportablerData.JsonToText(Transaction, 'creditKey', CreditKey);
        SportablerData.JsonToDecimal(Transaction, 'amount', Amount);


        if DebitKey = 'RECEIVABLE_CUSTOMER' then begin
            if not SportablerCustomers.Import(UserId, Customer) then exit(false);
            DebitType := "Gen. Journal Account Type"::Customer;
            DebitNo := Customer."No.";
        end else begin
            DebitType := "Gen. Journal Account Type"::"G/L Account";
            DebitNo := SportablerAccounts.GetAccount(DebitKey);
        end;

        if CreditKey = 'RECEIVABLE_CUSTOMER' then begin
            if not SportablerCustomers.Import(UserId, Customer) then exit(false);
            CreditType := "Gen. Journal Account Type"::Customer;
            CreditNo := Customer."No.";
        end else begin
            CreditType := "Gen. Journal Account Type"::"G/L Account";
            CreditNo := SportablerAccounts.GetAccount(CreditKey);
        end;
        exit(true);
    end;


    var
        SportablerData: Codeunit "Sportabler Data ADV";
        SportablerAccounts: Codeunit "Sportabler Accounts ADV";
        SportablerCustomers: Codeunit "Sportabler Customers ADV";
}