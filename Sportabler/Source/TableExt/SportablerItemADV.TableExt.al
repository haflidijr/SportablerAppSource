tableextension 1000001 "Sportabler Item ADV" extends Item
{
    fields
    {
        field(1000000; "Sportabler Item ADV"; Boolean)
        {
            Caption = 'Sportabler Item';
            DataClassification = CustomerContent;
            InitValue = false;
        }
    }
    trigger OnBeforeInsert()
    begin
        Rec."Sportabler Item ADV" := true;
    end;
}
