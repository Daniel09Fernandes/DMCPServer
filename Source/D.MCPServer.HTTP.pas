unit D.MCPServer.HTTP;

interface

uses
  System.Classes, System.JSON, System.SysUtils, System.IOUtils,
  IdContext, IdCustomHTTPServer, IdHTTPServer, IdGlobal,
   D.MCPServer.Transport.HTTP.Interf, D.MCPServer.STDIO;

type
  /// <summary>
  /// Implementing MCP transport using Indy's TIdHTTPServer.
  /// </summary>
  TIndyHTTPMCPTransport = class(TInterfacedObject, IDMCPTransport)
  private
    FDMCPCore: TDMCPServer;
    FHTTPServer: TIdHTTPServer;
    FPort: Integer;
    FHost: string;
    //FOnRequest: TProc<TJSONObject, TProc<TJSONObject>, TProc<TDMCPCallToolsContent>>;

    /// <summary>
    /// The main Indy event that handles POST requests.
    /// </summary>
    procedure DoCommandGet(AContext: TIdContext; ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);

    /// <summary>
    /// It handles other HTTP methods, such as OPTIONS for CORS.
    /// </summary>
    procedure DoCommandOther(AContext: TIdContext; ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
  public
    constructor Create(const AHost: string; APort: Integer; AMCPCore: TDMCPServer);
    destructor Destroy; override;
    procedure Start;
    procedure Stop;
    procedure SendResponse(const Response: TJSONObject); // Mantido para compatibilidade de interface
    function IsActive: Boolean;

    //property OnRequest: TProc<TJSONObject, TProc<TJSONObject>, TProc<TDMCPCallToolsContent>> read FOnRequest write FOnRequest;
  end;

  /// <summary>
  ///A factory for creating instances of the Indy HTTP transport.
  /// </summary>
  TIndyHTTPTransportFactory = class
    class function CreateTransport(const Config: TJSONObject; AMCPCore: TDMCPServer): IDMCPTransport;
  end;

implementation

{ TIndyHTTPMCPTransport }

constructor TIndyHTTPMCPTransport.Create(const AHost: string; APort: Integer; AMCPCore: TDMCPServer);
begin
  inherited Create;
  FHost := AHost;
  FPort := APort;

  FHTTPServer := TIdHTTPServer.Create(nil);
  FDMCPCore := AMCPCore;

  FHTTPServer.DefaultPort := FPort;
  FHTTPServer.OnCommandGet := DoCommandGet;
  FHTTPServer.OnCommandOther := DoCommandOther;
  FHTTPServer.MaxConnections := 100;
  FHTTPServer.KeepAlive := True;
  FHTTPServer.SessionTimeOut := 60000;
end;

destructor TIndyHTTPMCPTransport.Destroy;
begin
  if Assigned(FHTTPServer) then
  begin
    if FHTTPServer.Active then
      FHTTPServer.Active := False;
    FHTTPServer.Free;
  end;

  FreeAndNil(FDMCPCore);
  inherited;
end;

procedure TIndyHTTPMCPTransport.Start;
begin
  if not FHTTPServer.Active then
  begin
    FHTTPServer.Bindings.Clear;
    FHTTPServer.Bindings.Add.SetBinding(FHost, FPort);

    WriteLn(Format('Servidor MCP Indy iniciando em %s:%d', [FHost, FPort]));
    FHTTPServer.Active := True;
    WriteLn('Servidor MCP Indy ativo.');
  end;

  while FHTTPServer.Active do
    Continue;
end;

procedure TIndyHTTPMCPTransport.Stop;
begin
  if FHTTPServer.Active then
  begin
    FHTTPServer.Active := False;
    WriteLn('Servidor MCP Indy parado.');
  end;
end;

procedure TIndyHTTPMCPTransport.DoCommandOther(AContext: TIdContext; ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
begin
  if ARequestInfo.Command = 'OPTIONS' then
  begin
    AResponseInfo.ResponseNo := 200; // OK
    AResponseInfo.CustomHeaders.Values['Access-Control-Allow-Origin'] := '*';
    AResponseInfo.CustomHeaders.Values['Access-Control-Allow-Methods'] := 'POST, GET, OPTIONS';
    AResponseInfo.CustomHeaders.Values['Access-Control-Allow-Headers'] := 'Content-Type, Authorization, x-api-key';
    AResponseInfo.ContentText := '';
  end;
end;

procedure TIndyHTTPMCPTransport.DoCommandGet(AContext: TIdContext; ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
var
  LRequestContent: string;
  LJSON: TJSONObject;
  LResponseJSON: TJSONObject;
  LStringReader: TStreamReader;
begin
  AResponseInfo.CustomHeaders.Values['Access-Control-Allow-Origin'] := '*';
  AResponseInfo.ContentType := 'application/json';

  if ARequestInfo.Command = 'POST' then
  begin
    if Assigned(ARequestInfo.PostStream) and (ARequestInfo.PostStream.Size > 0) then
    begin
      ARequestInfo.PostStream.Position := 0;

      LStringReader := TStreamReader.Create(ARequestInfo.PostStream, TEncoding.UTF8);
      try
        LRequestContent := LStringReader.ReadToEnd;
      finally
        LStringReader.Free;
      end;
      AResponseInfo.ResponseNo := 200;

      LJSON := TJSONObject.ParseJSONValue(LRequestContent) as TJSONObject;
      LResponseJSON := FDMCPCore.ProcessRequest(LJSON);
      try
        AResponseInfo.ContentText := LResponseJSON.ToString;
      finally
        LJSON.Free;
        LResponseJSON.Free;
      end;
    end;
  end;
end;

procedure TIndyHTTPMCPTransport.SendResponse(const Response: TJSONObject);
begin.
  // Este método é mantido para compatibilidade com a interface IDMCPTransport,
end;

function TIndyHTTPMCPTransport.IsActive: Boolean;
begin
  Result := FHTTPServer.Active;
end;

{ TIndyHTTPTransportFactory }

class function TIndyHTTPTransportFactory.CreateTransport(const Config: TJSONObject; AMCPCore: TDMCPServer): IDMCPTransport;
var
  LHost: string;
  LPort: Integer;
begin
  // '0.0.0.0' permite ouvir em todas as interfaces de rede (útil para WSL/Docker)
  LHost := Config.GetValue('host', '0.0.0.0');
  LPort := Config.GetValue('port', 8080);
  Result := TIndyHTTPMCPTransport.Create(LHost, LPort, AMCPCore);

  Config.Free;
end;

end.
