page 1000010 "Sportabler Token Setup ADV"
{
    ApplicationArea = All;
    Caption = 'Sportabler Token Setup';
    PageType = StandardDialog;



    layout
    {
        area(content)
        {

            field(Token;
            Token)
            {
                ApplicationArea = All;
                Importance = Promoted;
                Caption = 'Sportabler Bearer Token';
                ToolTip = 'Token required to access your infromation from Sportabler, contect Sportabler if you dont have one.', Locked = false, MaxLength = 512;
            }
        }
    }
    var
        Token: Text[512];

    procedure GetToken(): Text[512]
    begin
        exit(Token);
    end;
}
