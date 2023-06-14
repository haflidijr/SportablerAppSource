pageextension 1000001 "Sportabler Navigation ADV" extends "Order Processor Role Center"

{
    actions
    {
        addlast(Sections)
        {
            group("Sportabler ADV")
            {
                action("SCustomer ADV")
                {
                    Caption = 'Customers';
                    ApplicationArea = All;
                    RunObject = page "Customer List";
                    RunPageView = where("Sportabler Customer ADV" = const(true));
                }
                action("Product ADV")
                {
                    Caption = 'Products';
                    ApplicationArea = All;
                    RunObject = page "Item List";
                    RunPageView = where("Sportabler Item ADV" = const(true));
                }
                action("Invoice ADV")
                {
                    Caption = 'Invoices';
                    ApplicationArea = All;
                    RunObject = page "Sales Invoice List";
                    RunPageView = where("Sportabler Sales Order ADV" = const(true));
                }
                action("PostedInvoice ADV")
                {
                    Caption = 'Posted Invoices';
                    ApplicationArea = All;
                    RunObject = page "Posted Sales Invoices";
                    RunPageView = where("Sportabler Post Inv ADV" = const(true));
                }

                action("Payments ADV")
                {
                    Caption = 'Transactions';
                    ApplicationArea = All;
                    RunObject = page "General Journal";
                }

                // Creates a sub-menu
                group("Import ADV")
                {
                    action("Manual ADV")
                    {
                        Caption = 'Manual';
                        ApplicationArea = All;
                        RunObject = page "Manual Data Collection ADV";
                    }
                    action("Schedual ADV")
                    {
                        Caption = 'Automatic';
                        ApplicationArea = All;
                        RunObject = page "Auto Data Collection ADV";
                    }
                }

                group("Settings ADV")
                {
                    action("Connection ADV")
                    {
                        Caption = 'Connection';
                        ApplicationArea = All;
                        RunObject = page "Sportabler Settings ADV";
                    }
                    action("Posting ADV")
                    {
                        Caption = 'Posting Groups';
                        ApplicationArea = All;
                        RunObject = page "Sportabler Posting Sttngs ADV";
                    }
                }
            }
        }
    }
}