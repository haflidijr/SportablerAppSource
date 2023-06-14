codeunit 1000006 "Sportabler Events ADV"
{
    procedure Import(DivisionIds: Text; StartTime: Text; EndTime: Text): Boolean
    var
        Batches: List of [Text];
        BatchId: Text;
        Data: List of [JsonToken];
    begin
        if not GetBatches(DivisionIds, StartTime, EndTime, Batches) then exit(false);
        foreach BatchId in Batches do begin
            if not DownloadEvents(BatchId, Data) then exit(false);
            if not HandleEvents(Data) then exit(false);
        end;
        exit(true);
    end;

    // Get divisions from Sportabler
    procedure DownloadEvents(BatchId: Text; var Data: List of [JsonToken]): Boolean
    begin
        if not SportablerApiConnection.AblerPagination('https://www.abler.io/accounting/batches/' + BatchId + '/events', 200, Data) then exit(false);
        exit(true);
    end;

    // Handle all booking events
    procedure HandleEvents(Data: List of [JsonToken]): Boolean
    var
        Events: JsonToken;
        SingleEvent: JsonToken;
    begin
        foreach Events in Data do begin
            if not Events.IsArray() then break;
            foreach SingleEvent in Events.AsArray() do HandleSingleEvent(SingleEvent.AsObject());
        end;
        exit(true);
    end;

    // Handle all booking events
    procedure HandleSingleEvent(SingleEvent: JsonObject): Boolean
    var
        Customer: Record Customer;
        SportablerEventId: Record "Sportabler Event Id ADV";

        SportablerInvoices: Codeunit "Sportabler Invoices ADV";

        AccountingEvent: Text;
        Category: Text;
        UserId: Text;
        OrderId: Text;
        EventTimestamp: Text;

        EventId: Text;

        PostDate: Date;

        Transactions: JsonArray;
        Transaction: JsonToken;
    begin
        SportablerData.JsonToText(SingleEvent, 'accountingEventId', AccountingEvent);
        SportablerData.JsonToText(SingleEvent, 'orderId', OrderId);
        SportablerData.JsonToText(SingleEvent, 'userId', UserId);
        SportablerData.JsonToText(SingleEvent, 'category', Category);
        SportablerData.JsonToText(SingleEvent, 'eventTimestamp', EventTimestamp);

        // Datetime string to Date
        PostDate := DT2Date(SportablerData.DateTimeFromString(EventTimestamp));

        // Create user if it doesn't exists
        if not SportablerCustomers.Import(UserId, Customer) then exit(false);

        // Create invoice if it doesn't exists
        if not SportablerInvoices.Import(OrderId, Category, Customer) then exit(false);

        EventId := EventTimestamp + '-' + AccountingEvent + '-' + OrderId;

        if SportablerEventId.Get(EventId) then exit(true);

        // Invoice created, no need to add transaction
        if AccountingEvent <> 'INVOICE_CREATED' then begin
            // Write each transaction to BC
            if not SportablerData.JsonToArray(SingleEvent, 'transactions', Transactions) then exit(false);
            foreach Transaction in Transactions do SportablerTransactions.Import(Transaction.AsObject(), PostDate, UserId);
        end;

        SportablerEventId.Init();
        SportablerEventId."Id ADV" := CopyStr(EventId, 1, 200);
        SportablerEventId.Insert();
        exit(true);

    end;


    // Get all batches for selected time and by divisions
    procedure GetBatches(DivisionIds: Text; StartTime: Text; EndTime: Text; var Batches: List of [Text]): Boolean
    var
        Data: List of [JsonToken];
    begin
        if not DownloadBatches(DivisionIds, StartTime, EndTime, Data) then exit(false);
        if not HandleBatches(Data, Batches) then exit(false);
        exit(true);
    end;



    // Download all batches for selected time and by divisions
    procedure DownloadBatches(DivisionIds: Text; StartTime: Text; EndTime: Text; var Data: List of [JsonToken]): Boolean
    begin
        if not SportablerApiConnection.AblerPagination('https://www.abler.io/accounting/batches?divisionIds=' + DivisionIds + '&startTime=' + StartTime + '&endTime=' + EndTime, 200, Data) then exit(false);
        exit(true);
    end;

    // Gets batch id from downloaded batches
    procedure HandleBatches(Data: List of [JsonToken]; var Batches: List of [Text]): Boolean
    var
        BatchGroup: JsonToken;
        Batch: JsonToken;
        BatchId: Text;
    begin
        foreach BatchGroup in Data do begin
            if not BatchGroup.IsArray() then break;
            foreach Batch in BatchGroup.AsArray() do begin
                if not SportablerData.JsonToText(Batch.AsObject(), 'id', BatchId) then exit(false);
                Batches.Add(BatchId);
            end;
        end;
        exit(true);
    end;

    var
        SportablerApiConnection: Codeunit "Sportabler API Connection ADV";
        SportablerData: Codeunit "Sportabler Data ADV";
        SportablerTransactions: Codeunit "Sportabler Transactions ADV";
        SportablerCustomers: Codeunit "Sportabler Customers ADV";

}
