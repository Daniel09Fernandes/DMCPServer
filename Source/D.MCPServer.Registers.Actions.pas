{MIT License

Copyright (c) 2025 Daniel Fernandes

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.}
{ ******************************************************* }

{ DMCP Library }

{ File     : D.MCPServer.Registers.Actions.pas }
{ Developer: Daniel Fernandes Rodrigures }
{ Email    : danielfernandesroddrigues@gmail.com }
{ this unit is a part of the Open Source. }
{ licensed under a MIT - see LICENSE.md}

{ ******************************************************* }
unit D.MCPServer.Registers.Actions;

interface

uses
  System.Generics.Collections,
  Classes, System.SysUtils,
  System.JSON, System.IOUtils, Rest.Json,
  D.MCPServer.STDIO,
  D.MCPServer.HTTP,
  D.MCPServer.Registers.Actions.Interf,
  D.MCPServer.Registers.Interf,
  D.MCPServer.Registers,
  D.MCPServer.Registers.Tools.Interf,
  D.MCPServer.ToolsCall.Response.Model,
  Variants,
  System.DateUtils;

type
  TTypeReturnGetParam = (trString, trInt, trFloat, trBool, trDateTime);

  TParamsHelper = class helper for TJSONObject
    function GetParam(ANameParam: string; ATypeReturn: TTypeReturnGetParam = trString): variant;
  end;

  TDMCPServerRegister = class(TInterfacedObject, IDMCPServerRegister)
  private
    FServerInfo: IMCPServerInfos;
    FRequired: TDictionary<string, IMCPServerToolsSchemaTypes>;
    FMcpProtocol: TMCPProtocol;
    FPort: string;
    FHost: string;

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
    function Protocol(AProtocol: TMCPProtocol = pMcpSTDIO):IDMCPServerRegister;
    function Port(APort: string): IDMCPServerRegister;
    function Host(AHost: string): IDMCPServerRegister;

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

function TDMCPServerRegister.Host(AHost: string): IDMCPServerRegister;
begin
  Result := Self;
  FHost := AHost;
end;

class function TDMCPServerRegister.New: IDMCPServerRegister;
begin
  Result := TDMCPServerRegister.Create;
end;

function TDMCPServerRegister.Port(APort: string): IDMCPServerRegister;
begin
  Result := Self;
  FPort := APort;
end;

function TDMCPServerRegister.Protocol(AProtocol: TMCPProtocol): IDMCPServerRegister;
begin
  Result := Self;
  FMcpProtocol := AProtocol;
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
  case FMcpProtocol of
    pMcpSTDIO:
      DMCPServer.Run(FServerInfo);

    pMcpHTTP:
      begin
        DMCPServer.SetServerInfo(FServerInfo);
        DMCPServer.InitializeCapabilities;

        var lDMCPhttp := TIndyHTTPTransportFactory.CreateTransport(
          TJSONObject.Create
            .AddPair('host', FHost)
            .AddPair('port', FPort),
         DMCPServer);

        lDMCPhttp.Start;
      end;
  end;
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

{ TParamsHelper }

function TParamsHelper.GetParam(ANameParam: string; ATypeReturn: TTypeReturnGetParam): variant;
var
  lParams: TJSONObject;
  lValue: string;
  lFormatSettings: TFormatSettings;
begin
  lValue := '';
  if not Self.TryGetValue(ANameParam, lValue) then
  begin
    lParams := Self.GetValue('params') as TJSONObject;
    if lParams <> nil then
    begin
      try
        lParams.TryGetValue(ANameParam, lValue);
      finally
        lParams.Free;
      end;
    end;
  end;

  case ATypeReturn of
     trString: Result := lValue;
     trInt:  Result := StrToIntDef(lValue, 0);
     trFloat:  Result := StrToFloatDef(lValue, 0);
     trBool:  Result := StrToBoolDef(lValue, False);
     trDateTime:
       begin
         if lValue.Contains('-') then
         begin
           lFormatSettings := TFormatSettings.Create;
           lFormatSettings.ShortDateFormat := 'yyyy-mm-dd';
           lFormatSettings.DateSeparator := '-';

           Result := StrToDate(lValue, lFormatSettings);
         end
         else
           Result := StrToDateDef(lValue, 0);
       end
   else
     Result := lValue;
  end;
end;

end.
