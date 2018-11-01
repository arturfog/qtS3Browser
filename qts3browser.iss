#define AppName "qts3browser"
#define AppVersion "1.0.4"
#define AppPublisher "Artur Fogiel"
#define AppURL "http://"
#define AppExeName "s3browser.exe"

[Setup]
AppId={{49cadf9a-c7ed-4b2e-96ea-055ab6fc640e}
AppName={#AppName}
AppVersion={#AppVersion}
AppPublisher={#AppPublisher}
AppPublisherURL={#AppURL}
AppSupportURL={#AppURL}
AppUpdatesURL={#AppURL}
DefaultDirName={pf}\QTS3browser\{#AppName}
DefaultGroupName=QTS3browser\{#AppName}
OutputDir="C:\"
OutputBaseFilename=qts3browser_win_setup
UninstallDisplayIcon={app}\{#AppExeName}
Compression=lzma
SolidCompression=yes

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"

[Files]
Source: "c:\projects\qts3browser\build\release\s3browser.exe"; DestDir: "{app}"
Source: "c:\projects\qts3browser\build\distrib\*"; DestDir: "{app}"; Flags: recursesubdirs createallsubdirs

[Icons]
Name: "{group}\{#AppName}"; Filename: "{app}\{#AppExeName}"
Name: "{group}\{cm:UninstallProgram,{#AppName}}"; Filename: "{uninstallexe}"
Name: "{commondesktop}\{#AppName}"; Filename: "{app}\{#AppExeName}"; Tasks: desktopicon

[Run]
Filename: "{app}\{#AppExeName}"; Description: "{cm:LaunchProgram,{#StringChange(AppName, '&', '&&')}}"; Flags: nowait postinstall skipifsilent unchecked
Filename: {app}\s3browser.exe; Description: "Launch qts3browser"; Flags: nowait postinstall skipifsilent

[UninstallRun]
Filename: "{cmd}"; Parameters: "/C""taskkill /im s3browser.exe /f /t"; Flags: runhidden
