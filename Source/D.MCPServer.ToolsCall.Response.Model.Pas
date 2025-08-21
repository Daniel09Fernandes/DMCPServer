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

{ File     : D.MCPServer.ToolsCall.Response.Model }
{ Developer: Daniel Fernandes Rodrigures }
{ Email    : danielfernandesroddrigues@gmail.com }
{ this unit is a part of the Open Source. }
{ licensed under a MIT - see LICENSE.md}

{ ******************************************************* }

unit D.MCPServer.ToolsCall.Response.Model;

interface

uses
  System.JSON, System.Generics.Collections, System.SysUtils,
  D.MCPServer.Registers.Tools.Interf;

type
  TDMCPCallToolsContent = class
  private
    FType: string;
    FText: string;
  public
    property &Type: string read FType write FType;
    property Text: string read FText write FText;

    constructor Create(AType:TProType; AText: string);
  end;

  TDMCPCallToolsResult = class
  private
    FContent: TObjectList<TDMCPCallToolsContent>;
  public
    property Content: TObjectList<TDMCPCallToolsContent> read FContent;

    constructor Create;
    destructor Destroy; override;
  end;

  TDMCPCallToolsResponseDTO = class
  private
    FJsonrpc: string;
    FId: Integer;
    FResult: TDMCPCallToolsResult;
  public
    property Jsonrpc: string read FJsonrpc write FJsonrpc;
    property Id: Integer read FId write FId;
    property &Result: TDMCPCallToolsResult read FResult write FResult;

    constructor Create;
    destructor Destroy; override;

    function ToJson: TJSONObject;
  end;

implementation

{ TDMCPCallToolsResponseDTO }

uses
  D.MCPServer.Registers.Tools,
  D.MCPServer.Consts;

constructor TDMCPCallToolsResponseDTO.Create;
begin
  FResult := TDMCPCallToolsResult.Create;
end;

destructor TDMCPCallToolsResponseDTO.Destroy;
begin
  FreeAndNil(FResult);
  inherited;
end;

function TDMCPCallToolsResponseDTO.ToJson: TJSONObject;
var
  ContentArray: TJSONArray;
  ContentItem: TDMCPCallToolsContent;
  ContentObj: TJSONObject;
  ResultObj: TJSONObject;
begin
  Result := TJSONObject.Create;
  try
    Result.AddPair(DMCP_REQ_PROTOCOL, FJsonrpc);
    Result.AddPair(DMCP_REQ_ID, TJSONNumber.Create(FId));

    ResultObj := TJSONObject.Create;
    ContentArray := TJSONArray.Create;

    for ContentItem in FResult.Content do
    begin
      ContentObj := TJSONObject.Create;
      ContentObj.AddPair(DMCP_JSON_TYPE, ContentItem.&Type);
      ContentObj.AddPair(ptText.ToString, ContentItem.Text);
      ContentArray.Add(ContentObj);
    end;

    ResultObj.AddPair(DMCP_RESP_CONTENT, ContentArray);
    Result.AddPair(DMCP_RESP_SERVER_RESULT, ResultObj);
  except
    Result.Free;
    raise;
  end;
end;

{ TDMCPCallToolsResult }

constructor TDMCPCallToolsResult.Create;
begin
  FContent := TObjectList<TDMCPCallToolsContent>.Create(True);
end;

destructor TDMCPCallToolsResult.Destroy;
begin
  FreeAndNil(FContent);
  inherited;
end;

{ TDMCPCallToolsContent }

constructor TDMCPCallToolsContent.Create(AType:TProType; AText: string);
begin
  FType := AType.toString;
  FText := AText;
end;

end.
