unit D.MCPServer.Registers;

interface

uses
  System.Generics.Collections,
  D.MCPServer.Registers.Interf,
  D.MCPServer.Registers.Tools.Interf;

type
  TDMCPRegisters = class(TInterfacedObject, IMCPServerInfos)
  private
    FServerName: string;
    FServerVersion: string;
    FITools: TList<IMCPServerTools>;

    procedure Initialize;
    procedure Finalize;
  public
    constructor Create;
    destructor Destroy; override;

    function SetServerName(AServerName: string): IMCPServerInfos;
    function GetServerName: string;
    function SetVersion(AServerVersion: string): IMCPServerInfos;
    function GetVersion: string;

    function Tools: TList<IMCPServerTools>; overload;
    function Tools(ATool: IMCPServerTools): IMCPServerInfos; overload;

    class function New: IMCPServerInfos;
  end;

implementation

{ TDMCPRegisters }

constructor TDMCPRegisters.Create;
begin
  inherited;
  Initialize;
end;

destructor TDMCPRegisters.Destroy;
begin
  Finalize;
  inherited;
end;

procedure TDMCPRegisters.Initialize;
begin
  FITools := TList<IMCPServerTools>.Create;
  FServerName := '';
  FServerVersion := '';
end;

procedure TDMCPRegisters.Finalize;
begin
  if Assigned(FITools) then
    FITools.Free;
end;

class function TDMCPRegisters.New: IMCPServerInfos;
begin
  Result := TDMCPRegisters.Create;
end;

function TDMCPRegisters.GetServerName: string;
begin
  Result := FServerName;
end;

function TDMCPRegisters.GetVersion: string;
begin
  Result := FServerVersion;
end;

function TDMCPRegisters.SetServerName(AServerName: string): IMCPServerInfos;
begin
  Result := Self;
  FServerName := AServerName;
end;

function TDMCPRegisters.SetVersion(AServerVersion: string): IMCPServerInfos;
begin
  Result := Self;
  FServerVersion := AServerVersion;
end;

function TDMCPRegisters.Tools: TList<IMCPServerTools>;
begin
  Result := FITools;
end;

function TDMCPRegisters.Tools(ATool: IMCPServerTools): IMCPServerInfos;
begin
  Result := Self;

  if Assigned(ATool) then
    FITools.Add(ATool);
end;

end.
