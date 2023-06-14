page 1000006 "Auto Data Collection ADV"
{
    ApplicationArea = All;
    Caption = 'Auto Data Collection';
    PageType = StandardDialog;
    UsageCategory = Administration;

    SourceTable = "Job Queue Entry";

    layout
    {
        area(content)
        {
            group(Active)
            {
                field(isActive; Active)
                {
                    ApplicationArea = All;
                    Caption = 'Active';
                    Editable = true;
                    ToolTip = 'Choose when to collect data', Locked = false, MaxLength = 100;

                    trigger OnValidate()
                    begin
                        if Active then Rec.SetStatus(Rec.Status::Ready) else Rec.SetStatus(Rec.Status::"On Hold")
                    end;
                }
            }
            group(When)
            {
                field("Run on Mondays"; Rec."Run on Mondays")
                {
                    ApplicationArea = All;
                    Caption = 'Run on Mondays';
                    Editable = not Active;
                    ToolTip = 'Choose when to collect data', Locked = false, MaxLength = 100;
                }
                field("Run on Tuesdays"; Rec."Run on Tuesdays")
                {
                    ApplicationArea = All;
                    Caption = 'Run on Tuesdays';
                    Editable = not Active;
                    ToolTip = 'Choose when to collect data', Locked = false, MaxLength = 100;
                }
                field("Run on Wednesdays"; Rec."Run on Wednesdays")
                {
                    ApplicationArea = All;
                    Caption = 'Run on Wednesdays';
                    Editable = not Active;
                    ToolTip = 'Choose when to collect data', Locked = false, MaxLength = 100;
                }
                field("Run on Thursdays"; Rec."Run on Thursdays")
                {
                    ApplicationArea = All;
                    Caption = 'Run on Thursdays';
                    Editable = not Active;
                    ToolTip = 'Choose when to collect data', Locked = false, MaxLength = 100;
                }
                field("Run on Fridays"; Rec."Run on Fridays")
                {
                    ApplicationArea = All;
                    Caption = 'Run on Fridays';
                    Editable = not Active;
                    ToolTip = 'Choose when to collect data', Locked = false, MaxLength = 100;
                }
                field("Run on Sundays"; Rec."Run on Sundays")
                {
                    ApplicationArea = All;
                    Caption = 'Run on Sundays';
                    Editable = not Active;
                    ToolTip = 'Choose when to collect data', Locked = false, MaxLength = 100;
                }
                field("Run on Saturdays"; Rec."Run on Saturdays")
                {
                    ApplicationArea = All;
                    Caption = 'Run on Saturdays';
                    Editable = not Active;
                    ToolTip = 'Choose when to collect data', Locked = false, MaxLength = 100;
                }
            }
        }
    }

    trigger OnInit()
    var
        JobQueueEntry: Record "Job Queue Entry";
    begin
        JobQueueEntry.SetFilter(JobQueueEntry."Object ID to Run", '50123');
        if JobQueueEntry.FindFirst() then
            Rec := JobQueueEntry else begin
            JobQueueEntry.Validate("Object Type to Run", JobQueueEntry."Object Type to Run"::Codeunit);
            JobQueueEntry.Validate("Object Id to Run", Codeunit::"Sportabler Import ADV");
            JobQueueEntry.Insert(true);
            JobQueueEntry.Validate("Earliest Start Date/Time", CurrentDateTime());
            JobQueueEntry.Validate("Recurring Job", true);
            JobQueueEntry.Modify(true);
        end;
        Active := JobQueueEntry.IsReadyToStart();
    end;

    var
        Active: Boolean;
}
