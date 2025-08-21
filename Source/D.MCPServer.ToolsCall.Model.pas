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

{ File     : D.MCPServer.ToolsCall.Model }
{ Developer: Daniel Fernandes Rodrigures }
{ Email    : danielfernandesroddrigues@gmail.com }
{ this unit is a part of the Open Source. }
{ licensed under a MIT - see LICENSE.md}

{ ******************************************************* }

unit D.MCPServer.ToolsCall.Model;

interface

uses
  System.Generics.Collections, REST.Json.Types, System.JSON;

{$M+}

type
  TArguments = class
  private
    FJsonObject: TJSONObject;
  public
    constructor Create;
    destructor Destroy; override;

    property JsonData: TJSONObject read FJsonObject;
    function ToJson: TJSONObject;
    class function FromJson(JsonObj: TJSONObject): TArguments;
  end;

  TParams = class
  private
    FArguments: TArguments;
    FName: string;
  published
    property Arguments: TArguments read FArguments;
    property Name: string read FName write FName;
  public
    constructor Create;
    destructor Destroy; override;

    function ToJson: TJSONObject;
    class function FromJson(JsonObj: TJSONObject): TParams;
  end;

  TMCPToolsCall = class
  private
    FId: Integer;
    FJsonrpc: string;
    FMethod: string;
    FParams: TParams;
  published
    property Id: Integer read FId write FId;
    property Jsonrpc: string read FJsonrpc write FJsonrpc;
    property Method: string read FMethod write FMethod;
    property Params: TParams read FParams;
  public
    constructor Create;
    destructor Destroy; override;
    function ToJson: TJSONObject;
    class function FromJson(const JsonString: string): TMCPToolsCall;
  end;

implementation

uses
  System.Rtti,
  D.MCPServer.Consts;

{ TParams }

constructor TParams.Create;
begin
  FArguments := TArguments.Create;
  inherited;
end;

destructor TParams.Destroy;
begin
  FArguments.Free;
  inherited;
end;

class function TParams.FromJson(JsonObj: TJSONObject): TParams;
var
  ArgumentsObj: TJSONObject;
begin
  Result := TParams.Create;
  Result.FName := JsonObj.GetValue<string>(DMCP_JSON_NAME);

  if JsonObj.TryGetValue<TJSONObject>(DMCP_RESP_TOOLS_ARGUMENTS, ArgumentsObj) then
    Result.FArguments := TArguments.FromJson(ArgumentsObj);
end;

function TParams.ToJson: TJSONObject;
begin
  Result := TJSONObject.Create;
  Result.AddPair(DMCP_JSON_NAME, FName);

  if FArguments.JsonData.Count > 0 then
    Result.AddPair(DMCP_RESP_TOOLS_ARGUMENTS, FArguments.ToJson);
end;

{ TMCPToolsCall }

constructor TMCPToolsCall.Create;
begin
  inherited;
  FParams := TParams.Create;
end;

destructor TMCPToolsCall.Destroy;
begin
  FParams.Free;
  inherited;
end;

class function TMCPToolsCall.FromJson(const JsonString: string): TMCPToolsCall;
var
  JsonObj: TJSONObject;
begin
  JsonObj := TJSONObject.ParseJSONValue(JsonString) as TJSONObject;
  try
    Result := TMCPToolsCall.Create;
    Result.FMethod := JsonObj.GetValue<string>(DMCP_REQ_METHOD);
    Result.FParams := TParams.FromJson(JsonObj.GetValue<TJSONObject>(DMCP_REQ_PARAMS));
    Result.FJsonrpc := JsonObj.GetValue<string>(DMCP_REQ_PROTOCOL);
    Result.FId := JsonObj.GetValue<Integer>(DMCP_REQ_ID);
  finally
    JsonObj.Free;
  end;
end;

function TMCPToolsCall.ToJson: TJSONObject;
begin
  Result := TJSONObject.Create;
  Result.AddPair(DMCP_REQ_METHOD, FMethod);
  Result.AddPair(DMCP_REQ_PARAMS, FParams.ToJson);
  Result.AddPair(DMCP_REQ_PROTOCOL, FJsonrpc);
  Result.AddPair(DMCP_REQ_ID, TJSONNumber.Create(FId));
end;

{ TArguments }

constructor TArguments.Create;
begin
  FJsonObject := TJSONObject.Create;
end;

destructor TArguments.Destroy;
begin
  FJsonObject.Free;
  inherited;
end;

class function TArguments.FromJson(JsonObj: TJSONObject): TArguments;
begin
  Result := TArguments.Create;
  if Assigned(JsonObj) then
    Result.FJsonObject := JsonObj.Clone as TJSONObject;
end;

function TArguments.ToJson: TJSONObject;
begin
  Result := FJsonObject.Clone as TJSONObject;
end;

end.
