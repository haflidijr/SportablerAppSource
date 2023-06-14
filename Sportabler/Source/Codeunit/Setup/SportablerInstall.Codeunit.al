// codeunit 50107 "Sportabler Install"
// {
//     Subtype = Install;

//     // Inizilize settings table for each company on install
//     // Create "All" option for divisions on install

//     trigger OnInstallAppPerCompany();
//     var
//         SportablerDivisions: Record "Sportabler Divisions";
//         SportablerSettings: Record "Sportabler Settings";
//     begin


//         SportablerSettings.DeleteAll();

//         // Create settings
//         SportablerSettings.Init();
//         SportablerSettings.No := 1;
//         SportablerSettings."Next Sportabler Customer No." := 1;
//         SportablerSettings."Next Sportabler Invoice No." := 1;
//         SportablerSettings.Mock := true;
//         SportablerSettings."Last Job" := CreateDateTime(19700101D, 000000T);
//         SportablerSettings.Insert();

//         SportablerDivisions.DeleteAll();

//         // All divisions
//         SportablerDivisions.Init();
//         SportablerDivisions."Club Id" := '*';
//         SportablerDivisions."Division Id" := '*';
//         SportablerDivisions."Division Name" := 'All';
//         SportablerDivisions.Insert();
//     end;
// }
