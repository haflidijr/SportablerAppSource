pageextension 1000000 "Sportabler Customer ADV" extends "Customer List"
{
    Caption = 'Sportabler Customer';

    layout
    {
        addafter("No.")
        {

            field("Registration No. ADV"; Rec."ADV Registration No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the customer Icelandic SSN.';
            }
            field("E-Mail ADV"; Rec."E-Mail")
            {
                ApplicationArea = All;
                ToolTip = 'Email';
            }
            field("Address ADV"; Rec.Address)
            {
                ApplicationArea = All;
                ToolTip = 'Address';
            }
            field("City ADV"; Rec.City)
            {
                ApplicationArea = All;
                ToolTip = 'City';
            }

        }
        modify("Responsibility Center")
        {
            Visible = false;
        }
        modify("Location Code")
        {
            Visible = false;
        }
        modify(Contact)
        {
            Visible = false;
        }

    }
}
