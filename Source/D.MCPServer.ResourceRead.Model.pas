unit D.MCPServer.ResourceRead.Model;

interface

uses
  REST.Json.Types;

type
  TParams = class
  private
    [JSONName('uri')]
    FUri: string;
  published
    property Uri: string read FUri write FUri;
  end;

  TMCPResourceRead = class
  private
    [JSONName('id')]
    FId: Integer;
    [JSONName('jsonrpc')]
    FJsonrpc: string;
    [JSONName('method')]
    FMethod: string;
    [JSONName('params')]
    FParams: TParams;
  public
    property Id: Integer read FId write FId;
    property Jsonrpc: string read FJsonrpc write FJsonrpc;
    property Method: string read FMethod write FMethod;
    property Params: TParams read FParams;

    constructor Create;
    destructor Destroy;
  end;

implementation

{ TMCPResourceRead }

constructor TMCPResourceRead.Create;
begin
  FParams := TParams.Create;
end;

destructor TMCPResourceRead.Destroy;
begin
  FParams.Free;
end;

end.
