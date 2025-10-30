unit D.MCPServer.ResourceRead.Response.Model;

interface

uses
  System.Generics.Collections,
  REST.Json.Types;

type
  TResourceContent = class
  private
    [JSONName('uri')]
    FUri: string;

    [JSONName('mimeType')]
    FMimeType: string;

    [JSONName('text')]
    FText: string;
  public
    property Uri: string read FUri write FUri;
    property MimeType: string read FMimeType write FMimeType;
    property Text: string read FText write FText;
  end;

  TResourceResult = class
  private
    [JSONName('contents')]
    FContents: TArray<TResourceContent>;
  public
    property Contents: TArray<TResourceContent> read FContents write FContents;

    destructor Destroy; override;
  end;

  TMCPResourceReadResponse = class
  private
    [JSONName('jsonrpc')]
    FJsonrpc: string;

    [JSONName('id')]
    FId: Integer;

    [JSONName('result')]
    FResult: TResourceResult;
  public
    property Jsonrpc: string read FJsonrpc write FJsonrpc;
    property Id: Integer read FId write FId;
    property Result: TResourceResult read FResult write FResult;

    constructor Create;
    destructor Destroy; override;
  end;

implementation

{ TResourceResult }

destructor TResourceResult.Destroy;
var
  I: Integer;
begin
  for I := 0 to High(FContents) do
    FContents[I].Free;
  inherited;
end;

{ TMCPResourceReadResponse }

constructor TMCPResourceReadResponse.Create;
begin
  inherited;
  FResult := TResourceResult.Create;
end;

destructor TMCPResourceReadResponse.Destroy;
begin
  FResult.Free;
  inherited;
end;

end.
