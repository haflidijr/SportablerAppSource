page 1000002 "Sportabler Divisions ADV"
{
    ApplicationArea = All;
    Caption = 'Sportabler Divisions';
    PageType = List;
    SourceTable = "Sportabler Divisions ADV";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(DivisionId; Rec."Division Id ADV")
                {
                    ToolTip = 'Specifies the value of the DivisionId field.';
                }
                field(DivisionName; Rec."Division Name ADV")
                {
                    ToolTip = 'Specifies the value of the DivisionName field.';
                }
                field(ClubId; Rec."Club Id ADV")
                {
                    ToolTip = 'Specifies the value of the ClubId field.';
                }
            }
        }
    }
}
