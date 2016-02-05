; Script generated by the Inno Setup Script Wizard.
; SEE THE DOCUMENTATION FOR DETAILS ON CREATING INNO SETUP SCRIPT FILES!

#define use_sql2005express
#define use_sql2008express
#define MyAppName "Jiffy Local Client"
#define MyAppVersion "1.5"
#define MyAppPublisher "Option Three Consulting Pvt Ltd, Inc."
#define MyAppURL "http://www.option3consulting.com/"
#define MyAppExeName "launch.exe"

[Setup]
; NOTE: The value of AppId uniquely identifies this application.
; Do not use the same AppId value in installers for other applications.
; (To generate a new GUID, click Tools | Generate GUID inside the IDE.)
AppId={{400C4C10-F33E-4DB3-9381-DCA368C8D315}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
;AppVerName={#MyAppName} {#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
DefaultDirName={pf}\{#MyAppName}
DisableProgramGroupPage=yes
OutputDir=C:\Users\O3\Desktop\helloworld\output
OutputBaseFilename=setup
Compression=lzma
SolidCompression=yes

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Files]
Source: "localclient-0.3.jar"; DestDir: "{app}"; Flags: ignoreversion
Source: "launch.bat"; DestDir: "{app}"; Flags: ignoreversion
Source: "launch.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "IEDriverServer.exe"; DestDir: "C:\Python27"; Flags: ignoreversion; Check: CopyInitialRepos
Source: "Automator\*"; DestDir: "C:\Program Files (x86)\IronPython 2.7\Automator"; Flags: ignoreversion; Check: CopyInitialRepos
Source: "AutomatorScriptEngine\*"; DestDir: "C:\Program Files (x86)\IronPython 2.7\AutomatorScriptEngine"; Flags: ignoreversion; Check: CopyInitialRepos
Source: "python-2.7.11.msi"; DestDir: "{app}"; Flags: dontcopy
Source: "IronPython-2.7.5.msi"; DestDir: "{app}"; Flags: dontcopy
Source: "InstallService.bat"; DestDir: "{app}"; Flags: dontcopy

; NOTE: Don't use "Flags: ignoreversion" on any shared system files

[Icons]
Name: "{commonprograms}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"
Name: "{commondesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon

[Run]
Filename: "{app}\{#MyAppExeName}"; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"; Flags: nowait postinstall skipifsilent

[Setup]
DisableReadyPage=yes



[Code]
procedure MyBeforeInstall();
begin
  MsgBox('About to install MyProg.exe as ' + CurrentFileName + '.', mbInformation, MB_OK);
end;



procedure DecodeVersion (verstr: String; var verint: array of Integer);
var
  i,p: Integer; s: string;
begin
  // initialize array
  verint := [0,0,0,0];
  i := 0;
  while ((Length(verstr) > 0) and (i < 4)) do
  begin
    p := pos ('.', verstr);
    if p > 0 then
    begin
      if p = 1 then s:= '0' else s:= Copy (verstr, 1, p - 1);
      verint[i] := StrToInt(s);
      i := i + 1;
      verstr := Copy (verstr, p+1, Length(verstr));
    end
    else
    begin
      verint[i] := StrToInt (verstr);
      verstr := '';
    end;
  end;

end;

procedure ExitProcess(exitCode:integer);
  external 'ExitProcess@kernel32.dll stdcall';

function CompareVersion (ver1, ver2: String) : Integer;
var
  verint1, verint2: array of Integer;
  i: integer;
begin

  SetArrayLength (verint1, 4);
  DecodeVersion (ver1, verint1);

  SetArrayLength (verint2, 4);
  DecodeVersion (ver2, verint2);

  Result := 0; i := 0;
  while ((Result = 0) and ( i < 4 )) do
  begin
    if verint1[i] > verint2[i] then
      Result := 1
    else
      if verint1[i] < verint2[i] then
        Result := -1
      else
        Result := 0;
    i := i + 1;
  end;

end;

function CheckPython(): Boolean;
var
  ErrorCode: Integer;
  JavaVer : String;
  Result1 : Boolean;
  Result2 : Boolean;
  PythonInstalled: Boolean;
  WebJRE: string;

begin
  PythonInstalled := RegKeyExists(HKLM, 'SOFTWARE\Wow6432Node\Python\PythonCore\2.7\InstallPath');
  if PythonInstalled then
  begin
    Result := true;
  end
  else
  if Result = false then
  begin
    MsgBox('This tool requires python Runtime Environment  <= v2.7 to run.Please download and install Python 2.7 and run this setup again.' ,mbConfirmation, MB_OK);
    ExitProcess(9);
  end;
end;

function CheckIronPython(): Boolean;
var
  ErrorCode: Integer;
  IronPythonInstalled: Boolean;
  WebJRE: string;

begin
  IronPythonInstalled := RegKeyExists(HKLM, 'SOFTWARE\Wow6432Node\IronPython\2.7\InstallPath');
  if IronPythonInstalled then
  begin
    Result := true;
  end
  else
  if Result = false then
  begin
    MsgBox('This Component requires Iron python 2.7 to run. Please download and install Iron Python 2.7 and run this setup again.' ,mbConfirmation, MB_OK);
    ExitProcess(9);
  end;
end;




function CheckJava (): Boolean;
var
  ErrorCode: Integer;
  JavaVer : String;
begin
    RegQueryStringValue(HKLM, 'SOFTWARE\JavaSoft\Java Runtime Environment', 'CurrentVersion', JavaVer);
    Result := false;
    if Length( JavaVer ) > 0 then
    begin
    	if CompareVersion(JavaVer,'1.7') >= 0 then
    	begin
    		Result := true;
    	end;
    end;
    if Result = false then
    begin
    	MsgBox('This tool requires Java Runtime Environment <= v1.7 to run. Please download and install JRE and run this setup again.', mbInformation, MB_OK);
      ExitProcess(9);
    end;
end;


function CheckandInstallJava (): Boolean;
var
  ErrorCode: Integer;
  JavaVer : String;
  Result1 : Boolean;
begin
    RegQueryStringValue(HKLM, 'SOFTWARE\JavaSoft\Java Runtime Environment', 'CurrentVersion', JavaVer);
    Result := false;
    if Length( JavaVer ) > 0 then
    begin
    	if CompareVersion(JavaVer,'1.7') >= 0 then
    	begin
    		Result := true;
    	end;
    end;
    if Result = false then
    begin
    	Result1 := MsgBox('This tool requires Java Runtime Environment <= v1.7 to run. Please download and install JRE and run this setup again.' + #13 + #10 + 'Do you want to download it now?',
    	  mbConfirmation, MB_YESNO) = idYes;
    	if Result1 = true then
    	begin
    		ShellExec('open',
    		  'http://www.java.com/en/download/manual.jsp#win',
    		  '','',SW_SHOWNORMAL,ewNoWait,ErrorCode);
          MsgBox('Closing setup, Please download and install JRE from the opened tab and and run this setup again.' ,mbConfirmation, MB_OK);
          ExitProcess(9); 
    	end;
      if Result1 = false then
      begin
         MsgBox('This tool requires Java Runtime Environment <= v1.7 to run. Please download and install JRE and run this setup again.' ,mbConfirmation, MB_OK);
         ExitProcess(9); 
      end;
    end;
end;





function CheckVS(): Boolean;
var
  ErrorCode: Integer;
  VSInstalled: Boolean;
  WebJRE: string;
  VSdistInstalled: Boolean;


begin
  VSInstalled := RegKeyExists(HKLM, 'SOFTWARE\Microsoft\VisualStudio\14.0\Setup');
  VSdistInstalled := RegKeyExists(HKLM, 'SOFTWARE\Wow6432Node\Microsoft\VisualStudio\10.0\VC\VCRedist');
  if VSInstalled and VSdistInstalled then
  begin
    Result := true;
  end
  else
  if Result = false then
  begin
    MsgBox('This Component requires Visual Studio-14.0 to run. Please download and install Visual Studio-14.0 and run this setup again.' ,mbConfirmation, MB_OK);
    ExitProcess(9);                                                                                              
  end;
end;

function CheckSelenium(): Boolean;
var
  ErrorCode: Integer;
  SeleniumInstalled: Boolean;
  ResultCode: integer;

begin
  if DirExists(ExpandConstant('C:\Python27\Lib\site-packages\selenium')) then 
  begin
    Result := true;
  end
  else
  if Result = false then
  begin
    MsgBox('This Component requires Selenium to run. Please Install Selenium and run this setup again.' ,mbConfirmation, MB_OK);
    ExitProcess(9);                                                                                          
  end;
end;

function CheckanInstallSelenium(): Boolean;
var
  ErrorCode: Integer;
  SeleniumInstalled: Boolean;
  ResultCode: integer;
  Result1: Boolean;

begin
  if DirExists(ExpandConstant('C:\Python27\Lib\site-packages\selenium')) then 
  begin
    Result := true;
  end
  else
  if Result = false then
  begin
    Result1 := MsgBox('This Component requires Selenium to run. Do you want to install it now?' ,mbConfirmation, MB_YESNO) = idYes;
    if Result1 then
    begin
      ExtractTemporaryFile('InstallService.bat');
      Exec(ExpandConstant('{tmp}\InstallService.bat'), '', '', SW_SHOW, ewWaitUntilTerminated, ResultCode);
    end
    else
    begin
      MsgBox('This Component requires Selenium to run. Please Install Selenium and run this setup again.' ,mbConfirmation, MB_OK);
      ExitProcess(9); 
    end                                                                                              
  end;
end;









function CheckandInstallPython(): Boolean;
var
  ErrorCode: Integer;
  Result1 : Boolean;
  Result2 : Boolean;
  PythonInstalled: Boolean;
  WebJRE: string;
begin
  PythonInstalled := RegKeyExists(HKLM, 'SOFTWARE\Wow6432Node\Python\PythonCore\2.7\InstallPath');
  if not PythonInstalled then
  begin
    Result1 := MsgBox('This tool requires python Runtime Environment  to run.  Do you want to install it now ?', mbConfirmation, MB_YESNO) = IDYES;
    if not Result1 then
    begin    
      Result := False;
      ExitProcess(9);
    end 
    else
    begin
      Result := True;
      ExtractTemporaryFile('python-2.7.11.msi')
      WebJRE:='"'+Expandconstant('{tmp}\python-2.7.11.msi')+'"'
      Exec('cmd.exe ','/c'+WebJRE,'', SW_HIDE,ewWaituntilterminated, Errorcode);
      MsgBox('If python environemet is installed then close the setup and Run again..', mbConfirmation, mb_ok);
      ExitProcess(9);
    end;
  end;
end;


function CheckanInstallIronPython(): Boolean;
var
  ErrorCode: Integer;
  Result1 : Boolean;
  Result2 : Boolean;
  IronPythonInstalled: Boolean;
  WebJRE: string;
begin
  IronPythonInstalled := RegKeyExists(HKLM, 'SOFTWARE\Wow6432Node\IronPython\2.7\InstallPath');
  if not IronPythonInstalled then
  begin
    Result1 := MsgBox('This Component requires Iron python 2.7 to run. Do you want to install it now ?', mbConfirmation, MB_YESNO) = IDYES;
    if not Result1 then
    begin    
      Result := False;
      ExitProcess(9);
    end 
    else
    begin
      Result := True;
      ExtractTemporaryFile('IronPython-2.7.5.msi')
      WebJRE:='"'+Expandconstant('{tmp}\IronPython-2.7.5.msi')+'"'
      Exec('cmd.exe ','/c'+WebJRE,'', SW_HIDE,ewWaituntilterminated, Errorcode);
      MsgBox('If iron python environemet is installed then close the setup and Run again', mbConfirmation, mb_ok);
      ExitProcess(9);
    end;
  end;
end;




var
  ActionPage: TInputOptionWizardPage;

procedure InitializeWizard;
begin
  ActionPage := CreateInputOptionPage(wpReady,
    'Optional Actions Test', 'Which actions should be performed?',
    'Please select all optional actions you want to be performed, then click Next.',
    False, False);

  ActionPage.Add('To install all dependencies for Desktop Component');
  ActionPage.Add('To install all dependencies for Web Component');
  ActionPage.Add('To install all dependencies for Unit Testing Component');

  ActionPage.Values[0] := True;
  ActionPage.Values[1] := False;
  ActionPage.Values[2] := False;
end;

function NextButtonClick(CurPageID: Integer): Boolean;
begin
  Result := True;
  if CurPageID = ActionPage.ID then begin
    if ActionPage.Values[0] then
    begin
      CheckandInstallJava();
      CheckanInstallIronPython();
      CheckVS();
    end;
    if ActionPage.Values[1] then
    begin
      CheckandInstallPython();
      CheckandInstallJava();
      CheckanInstallSelenium();
      CopyDlls();
    end; 
    if ActionPage.Values[2] then
      CheckJava();
  end;
end;

function CopyInitialRepos : Boolean;
begin
    if ActionPage.Values[1] then begin
      Result := True;
    end else begin
      Result := False;
   end;
end;


