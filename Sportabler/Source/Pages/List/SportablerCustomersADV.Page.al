page 1000001 "Sportabler Customers ADV"
{
    ApplicationArea = All;
    Caption = 'SportablerCustomer';
    PageType = List;
    SourceTable = Customer;
    SourceTableView = where("Sportabler Customer ADV" = const(true));
    CardPageID = "Customer Card";
    RefreshOnActivate = true;
    Editable = true;
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the number of the customer. The field is either filled automatically from a defined number series, or you enter the number manually because you have enabled manual number entry in the number-series setup.';
                }
                field("Registration No."; Rec."ADV Registration No.")
                {
                    ToolTip = 'Specifies the customer Icelandic SSN.';
                }
                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the customer''s name.';
                }
                field("E-Mail"; Rec."E-Mail")
                {
                    ToolTip = 'Specifies the customer''s email';
                }
                field(Address; Rec.Address)
                {
                    ToolTip = 'Specifies the customer''s address. This address will appear on all sales documents for the customer.';
                }
                field("Post Code"; Rec."Post Code")
                {
                    ToolTip = 'Specifies the cusomer''s postal code';
                }
                field(City; Rec.City)
                {
                    ToolTip = 'Specifies the customer''s city.';
                }
                field("Phone No."; Rec."Mobile Phone No.")
                {
                    ToolTip = 'Specifies the customer''s phone number.';
                }



            }
        }
    }
}
