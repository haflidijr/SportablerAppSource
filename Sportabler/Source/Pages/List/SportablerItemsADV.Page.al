page 1000003 "Sportabler Items ADV"
{
    ApplicationArea = All;
    Caption = 'SportablerItem';
    PageType = List;
    SourceTable = Item;
    UsageCategory = Administration;
    SourceTableView = where("Sportabler Item ADV" = const(true));
    CardPageID = "Item Card";


    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the number of the item.';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies what you are selling.';
                }
                field("Item Category Code"; Rec."Item Category Code")
                {
                    ToolTip = 'Specifies the category that the item belongs to. Item categories also contain any assigned item attributes.';
                }
                field(Type; Rec.Type)
                {
                    ToolTip = 'Specifies the type';
                }
                field("Base Unit Of Measure"; Rec."Base Unit of Measure")
                {
                    ToolTip = 'Base unit of measure';
                }
                field("Unit Price"; Rec."Unit Price")
                {
                    ToolTip = 'Specifies the price of one unit of the item or resource. You can enter a price manually or have it entered according to the Price/Profit Calculation field on the related card.';
                }

            }
        }
    }

}
