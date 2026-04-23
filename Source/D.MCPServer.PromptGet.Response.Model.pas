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

{ File     : D.MCPServer.PromptGet.Response.Model }
{ Developer: Daniel Fernandes Rodrigures }
{ Email    : danielfernandesroddrigues@gmail.com }
{ this unit is a part of the Open Source. }
{ licensed under a MIT - see LICENSE.md}

{ ******************************************************* }

unit D.MCPServer.PromptGet.Response.Model;

interface

uses
  System.JSON, System.SysUtils, System.Generics.Collections;

type
  TMCPPromptMessage = class
  private
    FRole: string;
    FContentType: string;
    FText: string;
  public
    property Role: string read FRole write FRole;
    property ContentType: string read FContentType write FContentType;
    property Text: string read FText write FText;

    constructor Create(ARole, AText: string; AContentType: string = 'text');
  end;

  TMCPPromptGetResult = class
  private
    FDescription: string;
    FMessages: TObjectList<TMCPPromptMessage>;
  public
    property Description: string read FDescription write FDescription;
    property Messages: TObjectList<TMCPPromptMessage> read FMessages;

    constructor Create;
    destructor Destroy; override;

    function ToJsonResult: TJSONObject;
  end;

implementation

uses
  D.MCPServer.Consts;

{ TMCPPromptMessage }

constructor TMCPPromptMessage.Create(ARole, AText: string; AContentType: string = 'text');
begin
  FRole := ARole;
  FText := AText;
  FContentType := AContentType;
end;

{ TMCPPromptGetResult }

constructor TMCPPromptGetResult.Create;
begin
  FMessages := TObjectList<TMCPPromptMessage>.Create(True);
end;

destructor TMCPPromptGetResult.Destroy;
begin
  FreeAndNil(FMessages);
  inherited;
end;

function TMCPPromptGetResult.ToJsonResult: TJSONObject;
var
  lMessagesArray: TJSONArray;
  lMsg: TMCPPromptMessage;
  lMsgObj: TJSONObject;
begin
  Result := TJSONObject.Create;
  try
    Result.AddPair(DMCP_JSON_DESCRIPTION, FDescription);

    lMessagesArray := TJSONArray.Create;
    for lMsg in FMessages do
    begin
      lMsgObj := TJSONObject.Create
        .AddPair(DMCP_RESP_PROMPTS_ROLE, lMsg.Role)
        .AddPair(DMCP_RESP_CONTENT, TJSONObject.Create
          .AddPair(DMCP_JSON_TYPE, lMsg.ContentType)
          .AddPair('text', lMsg.Text));
      lMessagesArray.Add(lMsgObj);
    end;

    Result.AddPair(DMCP_RESP_PROMPTS_MESSAGES, lMessagesArray);
  except
    Result.Free;
    raise;
  end;
end;

end.
