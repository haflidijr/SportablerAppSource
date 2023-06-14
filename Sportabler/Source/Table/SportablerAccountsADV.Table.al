table 1000000 "Sportabler Accounts ADV"
{
    Caption = 'Sportabler Accounts';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Key Id ADV"; Code[100])
        {
            Caption = 'Key Id';
            DataClassification = CustomerContent;
        }
        field(2; "Name ADV"; Text[300])
        {
            Caption = 'Name';
            DataClassification = CustomerContent;
        }
        field(3; "Account ADV"; Code[20])
        {
            Caption = 'Account';
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(PK; "Key Id ADV")
        {
            Clustered = true;
        }
    }
}
