page 1000008 "Sportabler Posting Sttngs ADV"
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

            field("Customer Template"; Rec."Customer Template ADV")
            {
                ApplicationArea = All;
                AssistEdit = true;
                Caption = 'Customer Template';
                Editable = false;
                Importance = Promoted;

                ToolTip = 'Specifies the VAT posting group for all invoces for Sportabler.', Locked = true, MaxLength = 100;

                trigger OnAssistEdit()
                begin
                    SportablerInputs.SelectCustomerTemplate(Rec);
                end;
            }

            field("Product Posting Group"; Rec."Product Posting Group ADV")
            {
                ApplicationArea = All;
                AssistEdit = true;
                Caption = 'Vat Posting Group';
                Editable = false;
                Importance = Promoted;

                ToolTip = 'Specifies the VAT posting group for all invoces for Sportabler.', Locked = true, MaxLength = 100;

                trigger OnAssistEdit()
                begin
                    if Rec."Customer Posting Group ADV" = '' then begin
                        Message('You need to select Customer Template first.');
                        exit;
                    end;
                    SportablerInputs.SelectProductPostingGroup(Rec);
                end;
            }

        }
    }


    trigger OnAfterGetRecord()
    var
    begin
        SportablerInputs.GetAccountStatus(MyStyleExpr);
    end;

    trigger OnInit()
    begin
        SportablerSettings.GetSettings(Rec);
    end;

    var
        SportablerSettings: Codeunit "Sportabler Settings ADV";
        SportablerInputs: Codeunit "Sportabler Inputs ADV";
        MyStyleExpr: Text;
}
