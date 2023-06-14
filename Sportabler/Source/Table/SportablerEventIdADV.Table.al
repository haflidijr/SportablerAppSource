table 1000002 "Sportabler Event Id ADV"
{
    Caption = 'Sportabler Event Id';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Id ADV"; Text[200])
        {
            Caption = 'Id';
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(PK; "Id ADV")
        {
            Clustered = true;
        }
    }
}
