codeunit 1000000 "Sportabler API Connection ADV"
{
    local procedure Abler(AuthToken: Text; Url: Text; var HasMore: Boolean; var Response: Text): Boolean
    var
        SportablerSettings: Codeunit "Sportabler Settings ADV";

        HttpClient: HttpClient;
        HttpRequestMessage: HttpRequestMessage;
        HttpResponseMessage: HttpResponseMessage;
        Headers: HttpHeaders;
        HasMoreHeader: List of [Text];
        HasMoreValue: Text;
    begin

        HasMore := false;

        // Check if abler should be redirected to docker host's computer
        if SportablerSettings.RunMock() then Url := Url.Replace('https://www.abler.io', 'http://host.containerhelper.internal:81');

        // Create and send request
        HttpRequestMessage.Method := 'GET';
        HttpRequestMessage.SetRequestUri(Url);
        HttpRequestMessage.GetHeaders(Headers);
        Headers.Add('Authorization', 'Bearer ' + AuthToken);
        HttpClient.Send(HttpRequestMessage, HttpResponseMessage);

        // Check if response is valid
        if not HttpResponseMessage.IsSuccessStatusCode then begin
            if (HttpResponseMessage.HttpStatusCode = 403) or (HttpResponseMessage.HttpStatusCode = 401) then Error('Auth token for Sportabler is not valid!');
            exit(false);
        end;

        // Get data from response    
        HttpResponseMessage.Content.ReadAs(Response);

        // Check if there are more values to get
        if HttpResponseMessage.Headers.GetValues('x-abler-page-has-next', HasMoreHeader) then begin
            HasMoreHeader.Get(1, HasMoreValue);
            HasMore := HasMoreValue.Contains('true');
        end;

        exit(true);
    end;

    procedure AblerPagination(Url: Text; PageSize: Integer; var Responses: List of [JsonToken]): Boolean
    var
        SportablerSettings: Codeunit "Sportabler Settings ADV";

        AuthToken: Text;
        Data: Text;
        HasMore: Boolean;
        Start: Integer;
        BaseUrl: Text;

        UrlSign: Text;

        Response: JsonToken;
    begin

        // Get token from settings
        if not SportablerSettings.GetToken(AuthToken) then exit(false);

        BaseUrl := url;
        Start := 0;
        HasMore := true;

        // Get data from all pages
        while HasMore do begin
            // Index correct page

            if BaseUrl.Contains('?') then UrlSign := '&' else UrlSign := '?';

            Url := BaseUrl + UrlSign + 'first=' + Format(PageSize) + '&after=' + Format(Start);
            Start := Start + PageSize;

            // Get data from request
            if not Abler(AuthToken, Url, HasMore, Data) then exit(false);

            // Create json token from data
            if not Response.ReadFrom(Data) then exit(false);
            Responses.Add(Response);
        end;
        exit(true);
    end;

    procedure AblerSingle(Url: Text; AuthToken: Text; var Response: JsonToken): Boolean
    var
        SportablerSettings: Codeunit "Sportabler Settings ADV";

        Data: Text;
        HasMore: Boolean;
    begin

        // Check if custom token was send, otherwise get token from settings
        if AuthToken = '' then
            if not SportablerSettings.GetToken(AuthToken) then exit(false);

        // Get data from request
        if not Abler(AuthToken, Url, HasMore, Data) then exit(false);

        // Create json token from data
        if not Response.ReadFrom(Data) then exit(false);

        exit(true);
    end;

}
