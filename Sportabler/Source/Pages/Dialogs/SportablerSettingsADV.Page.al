page 1000009 "Sportabler Settings ADV"
{
    ApplicationArea = All;
    DataCaptionExpression = 'Sportabler Settings';
    Caption = 'Sportabler Settings';

    UsageCategory = Administration;
    PageType = StandardDialog;

    SourceTable = "Sportabler Settings ADV";

    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = true;
    LinksAllowed = false;
    Extensible = false;

    layout
    {
        area(content)
        {
            field("Sportabler Bearer Token"; Rec."Sportabler Bearer Token ADV")
            {
                ApplicationArea = All;
                Caption = 'Sportabler Bearer Token';
                Editable = false;
                ToolTip = 'Token required to access your infromation from Sportabler, contect Sportabler if you dont have one.', Locked = false, MaxLength = 100;
                AssistEdit = true;
                Importance = Promoted;

                trigger OnAssistEdit()
                var
                    Cancel: Boolean;
                begin
                    if not SportablerSettings.SetSportablerToken(Cancel, Rec) then begin
                        if not Cancel then
                            Message('Token is not valid!')
                    end else begin
                        if not SportablerAccounts.Import() then Message('Could not fetch GetChartOfAccounts needed for club.');
                        if not SportablerDimensions.Import() then Message('Could not fetch Dimensions needed for club.');
                    end;

                end;
            }



            field("Accounts mapping"; SportablerInputs.GetAccountStatus(MyStyleExpr))
            {
                ApplicationArea = All;
                Caption = 'Sportabler accounts';
                Editable = false;
                ToolTip = 'Sportabler accounts', Locked = false, MaxLength = 100;
                AssistEdit = true;
                Importance = Promoted;
                StyleExpr = MyStyleExpr;

                trigger OnAssistEdit()
                var
                begin
                    SportablerInputs.SelectAccounts();
                end;
            }
        }
    }

    trigger OnInit()
    begin
        SportablerSettings.GetSettings(Rec);
    end;

    trigger OnAfterGetRecord()
    var
    begin
        SportablerInputs.GetAccountStatus(MyStyleExpr);
    end;

    var
        SportablerInputs: Codeunit "Sportabler Inputs ADV";
        SportablerSettings: Codeunit "Sportabler Settings ADV";
        SportablerAccounts: Codeunit "Sportabler Accounts ADV";
        SportablerDimensions: Codeunit "Sportabler Dimensions ADV";
        MyStyleExpr: Text;

}
