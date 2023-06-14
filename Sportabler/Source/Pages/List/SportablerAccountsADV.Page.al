page 1000020 "Sportabler Accounts ADV"
{
    ApplicationArea = All;
    Caption = 'Sportabler Accounts';
    PageType = ListPart;
    SourceTable = "Sportabler Accounts ADV";
    UsageCategory = Administration;


    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = true;
    LinksAllowed = false;
    Extensible = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {

                field("Key Id"; Rec."Key Id ADV")
                {

                    ToolTip = 'Specifies the value of the Account field.';

                    Editable = false;
                    Caption = 'Key';

                    AssistEdit = true;

                    trigger OnAssistEdit()
                    begin
                        selectAccount(Rec);
                    end;
                }

                field(Name; Rec."Name ADV")
                {

                    ToolTip = 'Specifies the value of the Account field.';

                    Caption = 'Name';
                    Editable = false;

                    AssistEdit = true;

                    trigger OnAssistEdit()
                    begin
                        selectAccount(Rec);
                    end;
                }
                field(Accounts; GetAccountName())
                {


                    ApplicationArea = All;
                    Caption = 'Account';
                    Editable = true;
                    AssistEdit = true;
                    Importance = Promoted;
                    ToolTip = 'Specifies the customer Icelandic SSN.';

                    StyleExpr = MyStyleExpr;

                    trigger OnAssistEdit()
                    begin
                        selectAccount(Rec);
                    end;
                }
            }
        }
    }

    var
        MyStyleExpr: Text;

    trigger OnAfterGetRecord()
    begin
        if Rec."Account ADV" = '' then
            MyStyleExpr := 'Unfavorable' else
            MyStyleExpr := 'Standard';
    end;


    procedure GetAccountName(): Text
    var
        GLAccount: Record "G/L Account";
    begin
        if GLAccount.Get(Rec."account ADV") then exit(GLAccount.Name);
        exit('SETUP NOW');
    end;

    procedure selectAccount(var SportablerAccountsRec: Record "Sportabler Accounts ADV")
    var
        GLAccount: Record "G/L Account";
        ChartOfAccountsGL: page "Chart of Accounts (G/L)";
    begin
        ChartOfAccountsGL.LookupMode(true);
        if ChartOfAccountsGL.RunModal() = Action::LookupOK then begin
            ChartOfAccountsGL.GetRecord(GLAccount);

            if GLAccount."Account Type" = "G/L Account Type"::Posting then begin
                rec."account ADV" := GLAccount."No.";
                MyStyleExpr := 'Standard';
                rec.Modify();
            end else
                Message('Account must be of type: Posting');
        end;
    end;
}
