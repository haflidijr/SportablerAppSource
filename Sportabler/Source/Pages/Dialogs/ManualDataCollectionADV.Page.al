page 1000007 "Manual Data Collection ADV"
{
    ApplicationArea = All;
    Caption = 'Manual Data Collection';
    PageType = StandardDialog;
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            field(FromDate; FromDate)
            {
                ApplicationArea = All;
                Caption = 'From';
                Editable = true;
                ToolTip = 'Date to collect data from.', Locked = false, MaxLength = 100;
            }
            field("To"; ToDate)
            {
                ApplicationArea = All;
                Caption = 'To';
                Editable = true;
                ToolTip = 'Date to collect data to.', Locked = false, MaxLength = 100;
            }
            field(Type; DivisionText)
            {
                ApplicationArea = All;
                Caption = 'Divisions';
                Editable = false;
                ToolTip = 'Divisions to collect data for.', Locked = false, MaxLength = 100;
                AssistEdit = true;
                Importance = Promoted;

                trigger OnAssistEdit()
                begin
                    SportablerInputs.SelectDivision(DivisionText, DivisionIds);
                end;
            }
        }
    }

    trigger OnInit()
    begin
        DivisionIds := SportablerDivisions.Get();
        DivisionText := 'All';

        ToDate := CurrentDateTime();
        FromDate := CreateDateTime(20000101D, 120000T);
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        if CloseAction = CloseAction::OK then
            if ToDate < FromDate then
                Message('Invalid date range. To date must be greater than from date.')
            else
                SportablerEvents.Import(SportablerData.ListToString(DivisionIds), SportablerData.FormatDateTime(FromDate), SportablerData.FormatDateTime(toDate));

        exit(true);

    end;

    var
        SportablerEvents: Codeunit "Sportabler Events ADV";
        SportablerDivisions: Codeunit "Sportabler Divisions ADV";
        SportablerData: Codeunit "Sportabler Data ADV";
        SportablerInputs: Codeunit "Sportabler Inputs ADV";
        FromDate: Datetime;
        ToDate: Datetime;
        DivisionIds: List of [Text];
        DivisionText: Text;

}
