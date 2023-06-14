tableextension 1000000 "Sportabler Customer ADV" extends Customer
{
    fields
    {
        field(1000000; "Sportabler Customer ADV"; Boolean)
        {
            Caption = 'sportablerCustomer';
            DataClassification = CustomerContent;
            InitValue = false;
        }
        field(1000001; "Sportabler User Id ADV"; Text[100])
        {
            Caption = 'Sportabler User Id';
            DataClassification = CustomerContent;
            InitValue = '';
        }
    }
    trigger OnBeforeInsert()
    begin
        Rec."Sportabler Customer ADV" := true;
    end;
}
