table 1000001 "Sportabler Divisions ADV"
{
    Caption = 'Sportabler Divisions';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Division Id ADV"; Code[20])
        {
            Caption = 'DivisionId';
            DataClassification = CustomerContent;
        }
        field(2; "Division Name ADV"; Text[100])
        {
            Caption = 'DivisionName';
            DataClassification = CustomerContent;
        }
        field(3; "Club Id ADV"; Code[20])
        {
            Caption = 'ClubId';
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(PK; "Division Id ADV")
        {
            Clustered = true;
        }
    }
}
