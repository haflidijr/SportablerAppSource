table 1000003 "Sportabler Settings ADV"
{
    Caption = 'Sportabler Settings';
    DataPerCompany = true;
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "No ADV"; Integer)
        {
            AutoIncrement = true;
            DataClassification = CustomerContent;
        }
        field(2; "Sportabler Bearer Token ADV"; Text[512])
        {
            Caption = 'Sportabler Bearer Token';
            DataClassification = CustomerContent;
        }
        field(3; "Gen. Prod. Posting Group ADV"; Code[20])
        {
            Caption = 'Gen. Prod. Posting Group';
            DataClassification = CustomerContent;
        }
        field(4; "VAT Prod. Posting Group ADV"; Code[20])
        {
            Caption = 'VAT Prod. Posting Group';
            DataClassification = CustomerContent;
        }
        field(5; "Next Sportabler Cust No. ADV"; Integer)
        {
            Caption = 'Next Sportabler Customer No.';
            DataClassification = CustomerContent;
        }
        field(6; "Next Sportabler Inv No. ADV"; Integer)
        {
            Caption = 'Next Sportabler Customer No.';
            DataClassification = CustomerContent;
        }
        field(7; "Customer Template ADV"; Code[20])
        {
            Caption = 'Customer Template';
            DataClassification = CustomerContent;
        }
        field(8; "Gen. Bus. Posting Group ADV"; Code[20])
        {
            Caption = 'Gen. Bus. Posting Group';
            DataClassification = CustomerContent;
        }
        field(9; "Customer Posting Group ADV"; Code[20])
        {
            Caption = 'Customer Posting Group';
            DataClassification = CustomerContent;
        }
        field(10; "Product Posting Group ADV"; Text[100])
        {
            Caption = 'Product Posting Group';
            DataClassification = CustomerContent;
        }
        field(11; "Last Job ADV"; DateTime)
        {
            Caption = 'Last date';
            DataClassification = CustomerContent;
        }
        field(12; "Next Sportabler Item No. ADV"; Integer)
        {
            Caption = 'Next Sportabler Customer No.';
            DataClassification = CustomerContent;
        }
        field(13; "Club Id ADV"; Text[2048])
        {
            Caption = 'Club Id';
            DataClassification = CustomerContent;
        }
        field(14; "Mock ADV"; Boolean)
        {
            Caption = 'Mock';
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(PK; "No ADV")
        {
            Clustered = true;
        }
    }

}
