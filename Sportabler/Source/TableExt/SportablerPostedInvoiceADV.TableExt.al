tableextension 1000002 "Sportabler Posted Invoice ADV" extends "Sales Invoice Header"
{
    fields
    {
        field(1000000; "Sportabler Post Inv ADV"; Boolean)
        {
            Caption = 'Sportabler Sales Invoice Header';
            DataClassification = CustomerContent;
            InitValue = false;
        }
    }

    trigger OnBeforeInsert()
    var
        SalesHeader: Record "Sales Header";
    begin
        if SalesHeader.Get(SalesHeader."Document Type"::Invoice, Rec."No.") then
            if SalesHeader."Sportabler Sales Order ADV" then
                Rec."Sportabler Post Inv ADV" := true
    end;
}
