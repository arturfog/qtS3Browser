#define AppName "qts3browser"
#define AppVersion "1.0.1"
#define AppPublisher "Artur Fogiel"
#define AppURL "http://"
#define AppExeName "s3browser.exe"

[Setup]
AppId={{258C031E-98C7-4609-9122-65A4D36274AF}
AppName={#AppName}
AppVersion={#AppVersion}
AppPublisher={#AppPublisher}
AppPublisherURL={#AppURL}
AppSupportURL={#AppURL}
AppUpdatesURL={#AppURL}
DefaultDirName={pf}\Artur Fogiel\{#AppName}
DefaultGroupName=Artur Fogiel\{#AppName}
OutputDir="C:\"
OutputBaseFilename=qts3browser_win_setup
UninstallDisplayIcon={app}\{#AppExeName}
Compression=lzma
SolidCompression=yes

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"

[Files]
Source: "c:\projects\qts3browser\release\s3browser.exe"; DestDir: "{app}"
Source: "c:\projects\aws\*.dll"; DestDir: "{app}"; Flags: recursesubdirs createallsubdirs

[Icons]
Name: "{group}\{#AppName}"; Filename: "{app}\{#AppExeName}"
Name: "{group}\{cm:UninstallProgram,{#AppName}}"; Filename: "{uninstallexe}"
Name: "{commondesktop}\{#AppName}"; Filename: "{app}\{#AppExeName}"; Tasks: desktopicon

[Run]
Filename: "{app}\{#AppExeName}"; Description: "{cm:LaunchProgram,{#StringChange(AppName, '&', '&&')}}"; Flags: nowait postinstall skipifsilent unchecked
Filename: {app}\s3browser.exe; Description: "Launch qts3browser"; Flags: nowait postinstall skipifsilent

[UninstallRun]
Filename: "{cmd}"; Parameters: "/C""taskkill /im s3browser.exe /f /t"; Flags: runhidden
