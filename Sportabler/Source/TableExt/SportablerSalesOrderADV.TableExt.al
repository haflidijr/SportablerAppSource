tableextension 1000003 "Sportabler Sales Order ADV" extends "Sales Header"
{
    fields
    {
        field(1000000; "Sportabler Sales Order ADV"; Boolean)
        {
            Caption = 'Sportabler Sales Order';
            DataClassification = CustomerContent;
            InitValue = false;
        }
        field(1000001; "Sportabler Invoice Id ADV"; Decimal)
        {
            Caption = 'Sportabler Invoice Id';
            DataClassification = CustomerContent;
            InitValue = -1;
        }
    }
    trigger OnBeforeInsert()
    begin
        Rec."Sportabler Sales Order ADV" := true;
    end;
}
