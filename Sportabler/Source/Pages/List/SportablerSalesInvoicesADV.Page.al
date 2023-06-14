page 1000005 "Sportabler Sales Invoices ADV"
{
    ApplicationArea = All;
    Caption = 'SportablerSalesInvoice';
    PageType = List;
    SourceTable = "Sales Header";
    UsageCategory = Administration;
    SourceTableView = where("Sportabler Sales Order ADV" = const(true), "Document Type" = filter(Invoice));
    CardPageId = "Sales Invoice";

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ToolTip = 'Customer ssn';
                }
                field("Sell-to Customer No."; Rec."Sell-to Customer No.")
                {
                    Caption = 'Sell-to Customer No.';
                    TableRelation = Customer;
                    ToolTip = 'Customer No.';
                }
                field("Sell-to Customer Name"; Rec."Sell-to Customer Name")
                {
                    ToolTip = 'Customer Name';
                }
                field("External Document No."; Rec."External Document No.")
                {
                    ToolTip = 'Document No.';
                }
                field("Location Code"; Rec."Location Code")
                {
                    ToolTip = 'Location Code';
                }
                field("Assigned User ID"; Rec."Assigned User ID")
                {
                    ToolTip = 'User Id';
                }
                field(Amount; Rec.Amount)
                {
                    ToolTip = 'Total amount';
                }
                field("Document Date"; Rec."Document Date")
                {
                    ToolTip = 'Document Date';
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Status';
                }
            }
        }
    }
}