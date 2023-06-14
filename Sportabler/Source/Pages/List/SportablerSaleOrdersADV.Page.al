page 1000004 "Sportabler Sale Orders ADV"
{
    ApplicationArea = All;
    Caption = 'SportablerSaleOrders';
    PageType = List;
    SourceTable = "Sales Header";
    UsageCategory = Administration;
    SourceTableView = where("Sportabler Sales Order ADV" = const(true), "Document Type" = FILTER(Order));
    CardPageId = "Sales Order";

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'customer ssn';
                }
                field("Sell-to Customer No."; Rec."Sell-to Customer No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Customer number';
                }
                field("Sell-to Customer Name"; Rec."Sell-to Customer Name")
                {
                    ToolTip = 'Customer name';
                }
                field("External Document No."; Rec."External Document No.")
                {
                    ToolTip = 'Document No.';
                }
                field("Location Code"; Rec."Location Code")
                {
                    ToolTip = 'Location';
                }
                field("Assigned User ID"; Rec."Assigned User ID")
                {
                    ToolTip = 'User Id';
                }
                field("Document Date"; Rec."Document Date")
                {
                    ToolTip = 'Date of document';
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'boolean status';
                }
            }
        }
    }

}
