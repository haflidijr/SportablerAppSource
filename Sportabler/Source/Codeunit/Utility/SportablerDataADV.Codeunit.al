codeunit 1000011 "Sportabler Data ADV"
{
    // datetime to TZ datetime string
    procedure FormatDateTime(DT: Datetime): Text
    var
        DTTime: Time;
        DTDate: Date;
        Hour: Text;
        Minute: Text;
        Day: Integer;
        DayText: Text;
        Month: Integer;
        MonthText: Text;
        Year: Integer;
    begin
        DTTime := DT2Time(dt);
        DTDate := DT2Date(dt);

        Day := Date2DMY(DTDate, 1);
        Month := Date2DMY(DTDate, 2);
        Year := Date2DMY(DTDate, 3);

        Hour := Format(DTTime).Split(':').Get(1);
        Minute := Format(DTTime).Split(':').Get(2);

        DayText := Format(Day);
        MonthText := Format(Month);

        if Day < 10 then DayText := '0' + DayText;
        if Month < 10 then MonthText := '0' + MonthText;

        exit(Format(Year) + '-' + MonthText + '-' + DayText + 'T' + Hour + ':' + Minute + ':00.000Z');
    end;

    // TZ datetime string to datetime
    procedure DateTimeFromString(DateTimeString: Text): DateTime
    var
        DT: DateTime;
    begin
        Evaluate(DT, DateTimeString);
        exit(DT);
    end;

    // Index in json and return text
    procedure JsonToText(object: JsonObject; index: Text; var response: Text): Boolean
    var
        jasonToken: JsonToken;
    begin
        if not object.Get(index, jasonToken) then exit(false);
        if not jasonToken.IsValue() then exit(false);
        if jasonToken.AsValue().IsNull() or jasonToken.AsValue().IsUndefined() then begin
            response := '';
            exit(true);
        end;
        response := jasonToken.AsValue().AsText();
        exit(true)
    end;

    // Index in json and return decimal
    procedure JsonToDecimal(object: JsonObject; index: Text; var response: Decimal): Boolean
    var
        jasonToken: JsonToken;
    begin
        if not object.Get(index, jasonToken) then exit(false);
        if not jasonToken.IsValue() then exit(false);
        if jasonToken.AsValue().IsNull() or jasonToken.AsValue().IsUndefined() then begin
            response := 0;
            exit(true);
        end;
        response := jasonToken.AsValue().AsDecimal();
        exit(true);
    end;

    // Index in json and return json array
    procedure JsonToArray(object: JsonObject; index: Text; var response: JsonArray): Boolean
    var
        jasonToken: JsonToken;
    begin
        if not object.Get(index, jasonToken) then exit(false);
        if not jasonToken.IsArray() then exit(false);
        response := jasonToken.AsArray();
        exit(true);
    end;

    // Index in json and return json object
    procedure JsonToObject(object: JsonObject; index: Text; var response: JsonObject): Boolean
    var
        jasonToken: JsonToken;
    begin
        if not object.Get(index, jasonToken) then exit(false);
        if not jasonToken.IsObject() then exit(false);
        response := jasonToken.AsObject();
        exit(true);
    end;

    // List to comma separated string
    procedure ListToString(Strings: List of [Text]): Text
    var
        Output: Text;
        String: Text;
    begin
        Output := '';
        foreach String in Strings do
            if Output = '' then Output := String else Output := Output + ',' + String;
        exit(Output);
    end;

}
