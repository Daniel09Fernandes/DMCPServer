unit D.MCPServer.Registers.Actions;

interface

uses
  System.Generics.Collections,
  Classes, System.SysUtils,
  System.JSON, System.IOUtils, Rest.Json,
  D.MCPServer.STDIO,
  D.MCPServer.Registers.Actions.Interf,
  D.MCPServer.Registers.Interf,
  D.MCPServer.Registers,
  D.MCPServer.Registers.Tools.Interf,
  D.MCPServer.ToolsCall.Response.Model;

type
  TDMCPServerRegister = class(TInterfacedObject, IDMCPServerRegister)
  private
    FServerInfo: IMCPServerInfos;
    FRequired: TDictionary<string, IMCPServerToolsSchemaTypes>;

    procedure Initialize;
    procedure Finalize;
  public
    constructor Create;
    destructor Destroy; override;

    function RegisterAction(const ActionName, ActionDescription: string; const ActionProc: TMCPAction): IDMCPServerRegister;
    function ServerInfo: IMCPServerInfos;
    function Required: TDictionary<string, IMCPServerToolsSchemaTypes>;
    function SetLogs(AEnabledLogs: Boolean): IDMCPServerRegister;
    function Execute(AStringResponse: string; var AParams: TJSONObject; var AResult: TDMCPCallToolsResult; var AError: TDMCPCallToolsContent; AExecute: TProc): IDMCPServerRegister;
    procedure Run;
    class function New: IDMCPServerRegister;
  end;

implementation

{ TDMCPServerRegister }

constructor TDMCPServerRegister.Create;
begin
  inherited;
  Initialize;
end;

destructor TDMCPServerRegister.Destroy;
begin
  Finalize;
  inherited;
end;

function TDMCPServerRegister.Execute(AStringResponse: string; var AParams: TJSONObject; var AResult: TDMCPCallToolsResult; var AError: TDMCPCallToolsContent; AExecute: TProc): IDMCPServerRegister;
var
  EnableLog: Boolean;
begin
  try
    try
      if AParams.TryGetValue('EnableLog', EnableLog) then
        SetLogs(EnableLog);

    AExecute;

    AResult := TDMCPCallToolsResult.Create;
    AResult.Content.AddRange(
      TDMCPCallToolsContent.Create(ptText, AStringResponse));
    AError := nil;
  finally
    AParams.Free;
  end;
  except
    on E: Exception do
    begin
      AError := TDMCPCallToolsContent.Create(ptText, 'Erro no servido: '+ E.Message);
      TDMCPServer.WriteToLog('Error: '+ E.Message);
      AResult := nil;
    end;
  end;
end;

procedure TDMCPServerRegister.Initialize;
begin
  FRequired := TDictionary<string, IMCPServerToolsSchemaTypes>.Create;
  FServerInfo := nil;
end;

procedure TDMCPServerRegister.Finalize;
begin
  if Assigned(FRequired) then
    FRequired.Free;

  FServerInfo := nil;
end;

class function TDMCPServerRegister.New: IDMCPServerRegister;
begin
  Result := TDMCPServerRegister.Create;
end;

function TDMCPServerRegister.RegisterAction(const ActionName, ActionDescription: string; const ActionProc: TMCPAction): IDMCPServerRegister;
begin
  DMCPServer.Actions.Add(ActionName, ActionProc);
  Result := Self;
end;

function TDMCPServerRegister.Required: TDictionary<string, IMCPServerToolsSchemaTypes>;
begin
  Result := FRequired;
end;

procedure TDMCPServerRegister.Run;
begin
  DMCPServer.Run(FServerInfo);
end;

function TDMCPServerRegister.ServerInfo: IMCPServerInfos;
begin
  if not Assigned(FServerInfo) then
    FServerInfo := TDMCPRegisters.New;

  Result := FServerInfo;
end;

function TDMCPServerRegister.SetLogs(AEnabledLogs: Boolean): IDMCPServerRegister;
begin
  DMCPServer.SetLogs(AEnabledLogs);
  Result := Self;
end;

end.
