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

{ File     : D.MCPServer.STDIO }
{ Developer: Daniel Fernandes Rodrigures }
{ Email    : danielfernandesroddrigues@gmail.com }
{ this unit is a part of the Open Source. }
{ licensed under a MIT - see LICENSE.md}

{ ******************************************************* }

unit D.MCPServer.STDIO;

interface

uses
  System.SysUtils, System.Classes,
  System.JSON, Rest.Json,
  System.Generics.Collections,
  {$IFDEF MSWINDOWS}
    Winapi.Windows,
  {$ENDIF}
  D.MCPServer.ToolsCall.Model,
  D.MCPServer.Registers.Interf,
  D.MCPServer.ToolsCall.Response.Model,
  D.MCPServer.Registers,
  D.MCPServer.Registers.Tools,
  D.MCPServer.Registers.Actions.Interf;

type
  TMCPServerActions = TMCPAction;

  TDMCPServer = class
  private
  class var
     FEnabledLogs: Boolean;
  var
    FActions: TDictionary<string, TMCPServerActions>;
    FCapabilities: TJSONArray;
    FServerInfo: IMCPServerInfos;
    FNotReply: Boolean;
    procedure InitializeCapabilities;
    function ProcessRequest(const ARequest: TJSONObject): TJSONObject;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Run(AServerInfo: IMCPServerInfos);
    Procedure SetLogs(AEnabledLogs: Boolean);

    class procedure WriteToLog(const AMessage: string);
    property Actions: TDictionary<string, TMCPServerActions> read FActions write FActions;
  end;

  var
    DMCPServer: TDMCPServer;

implementation

{ TDMCPServer }

uses
  StrUtils,
  NetEncoding,
  D.MCPServer.Consts,
  D.MCPServer.Registers.Tools.Interf, System.IOUtils;

class procedure TDMCPServer.WriteToLog(const AMessage: string);
var
  lLogFile: string;
  lStream: TFileStream;
  lText: string;
  lBytes: TBytes;
  lAttempts: Integer;
begin
  if not FEnabledLogs then Exit;

  lLogFile := ExtractFilePath(ParamStr(0)) + FormatDateTime('yy_mm_dd_hh', Now) + DMCP_LOG;
  lText := '['+DateTimeToStr(Now) + ']: ' + AMessage;
  lBytes := TEncoding.UTF8.GetBytes(lText);

  lAttempts := 0;
  repeat
    try
      lStream := TFile.Create(lLogFile);
      try
        lStream.Seek(0, TSeekOrigin.soEnd);
        lStream.Write(lBytes, Length(lBytes));
        Exit;
      finally
        lStream.Free;
      end;
    except
      on E: EFileStreamError do
      begin
        Inc(lAttempts);
        if lAttempts > 5 then Exit;
          Sleep(50);
      end;
    end;
  until False;
end;

constructor TDMCPServer.Create;
begin
 inherited;
  FEnabledLogs := False;
  FNotReply := False;
  try
    FActions := TDictionary<string, TMCPAction>.Create;
    FCapabilities := TJSONArray.Create;
  except
    on E: Exception do
    begin
      WriteToLog(DMCP_LOG_ERROR_INIT + E.Message);
      raise;
    end;
  end;
end;

destructor TDMCPServer.Destroy;
begin
  FActions.Free;
  FCapabilities.Free;
  inherited;
end;

procedure TDMCPServer.InitializeCapabilities;
var
  lJsonProp: TJSONObject;
  lJsonTool: TJSONObject;
  lJsonRequired: TJSONArray;
  lRequired: string;
  lProp: TPair<string, TProType>;
  lTool: IMCPServerTools;
begin
  for lTool in FServerInfo.Tools do
  begin
    lJsonProp := TJSONObject.Create;
    for lProp in lTool.InputSchema.GetProperties do
    begin
       lJsonProp
        .AddPair(lProp.Key,  TJSONObject.Create
          .AddPair(DMCP_JSON_TYPE, lProp.Value.ToString))
    end;

    lJsonRequired := TJSONArray.Create;

    for lRequired in  lTool.InputSchema.GetRequired do
      lJsonRequired.Add(lRequired);

    lJsonTool := TJSONObject.Create
     .AddPair(DMCP_JSON_NAME, lTool.GetName)
     .AddPair(DMCP_JSON_INPUT_SCHEMA, TJSONObject.Create
         .AddPair(DMCP_JSON_TYPE, lTool.InputSchema.GetType.ToString)
         .AddPair(DMCP_JSON_PROPERTIES, lJsonProp)
       .AddPair(DMCP_JSON_REQUIRED, lJsonRequired)
       .AddPair(DMCP_JSON_ADT_PROPS, lTool.InputSchema.GetAdditionalProperties)
       .AddPair(DMCP_JSON_SCHEMA, DMCP_JSON_SCHEMA_VL)
       );

     FCapabilities.AddElement(lJsonTool);
  end;
end;

function TDMCPServer.ProcessRequest(const ARequest: TJSONObject): TJSONObject;
var
  lMethod: string;
  lProtocol: TJSONValue;
  lToolsCallResult: TDMCPCallToolsResult;
  lToolsCallError: TDMCPCallToolsContent;
  lJsonArgument: TJSONObject;
  lMCPJson: TJSONObject;
  lRequest: TMCPToolsCall;
  lCapabilities: TJSONArray;
  lJsonArrayResources: TJSONArray;

  procedure GenerationExceptResponse(AMessage: string);
  begin
    Result.AddPair(DMCP_RESP_SERVER_ERROR, TJSONObject.Create
      .AddPair(DMCP_RESP_SERVER_ERROR_CODE, DMCP_RESP_SERVER_ERROR_CODE_DEFAULT)
      .AddPair(DMCP_RESP_SERVER_ERROR_MESSAGE, AMessage));
  end;
begin
  lProtocol := nil;
  FNotReply := False;
  Result := TJSONObject.Create;
  try
    Result.AddPair(DMCP_REQ_PROTOCOL, ARequest.GetValue(DMCP_REQ_PROTOCOL).Value);

    if ARequest.GetValue(DMCP_REQ_ID) <> nil then
      Result.AddPair(DMCP_REQ_ID, ARequest.GetValue(DMCP_REQ_ID).Clone as TJSONValue)
    else
      Result.AddPair(DMCP_REQ_ID, TJSONNull.Create);

    if  Assigned(ARequest.GetValue(DMCP_REQ_PARAMS)) then
      lProtocol := ARequest.GetValue(DMCP_REQ_PARAMS).FindValue(DMCP_REQ_PROTOCOL_VERSION);

    lMethod := ARequest.GetValue(DMCP_REQ_METHOD).Value;

    case AnsiIndexStr(LowerCase(lMethod), [DMCP_REQ_METHOD_INITIALIZATION, DMCP_REQ_METHOD_TOOLS_LIST, DMCP_REQ_METHOD_RESOURCE_LIST,
       DMCP_REQ_METHOD_PROMPT_LIST, DMCP_REQ_METHOD_NOTIFICATION_INITIALIZED, DMCP_REQ_METHOD_TOOLS_CALL]) of

      DMCP_REQ_METHOD_INITIALIZATION_IDX:
        begin
          lMCPJson := TJSONObject.Create;
          lMCPJson.AddPair(DMCP_RESP_PROTOCOL_VERSION, lProtocol.Clone as TJSONValue);
          lMCPJson.AddPair(DMCP_RESP_CAPABILITES, TJSONObject.Create
            .AddPair(DMCP_RESP_TOOLS,TJSONObject.Create));

          lMCPJson.AddPair(DMCP_RESP_SERVER_INFO, TJSONObject.Create
            .AddPair(DMCP_RESP_SERVER_NAME, FServerInfo.GetServerName)
            .AddPair(DMCP_RESP_SERVER_VERSION, FServerInfo.GetVersion));

          Result.AddPair(DMCP_RESP_SERVER_RESULT, lMCPJson);

          TDMCPServer.WriteToLog(DMCP_LOG_CALL_INIT);
        end;

     DMCP_REQ_METHOD_TOOLS_LIST_IDX:
        begin
          lCapabilities :=  FCapabilities.Clone as TJSONArray;

          Result.AddPair(DMCP_RESP_SERVER_RESULT, TJSONObject.Create
            .AddPair(DMCP_RESP_TOOLS, TJSONArray(lCapabilities)));

          TDMCPServer.WriteToLog(DMCP_LOG_CALL_TOOLS_LIST);
        end;

      DMCP_REQ_METHOD_RESOURCE_LIST_IDX:
        begin
          lJsonArrayResources := TJSONArray.Create;
          lJsonArrayResources.Add(TJSONObject.Create
            .AddPair(DMCP_RESOURCE_LIST_URI, DMCP_RESOURCE_LIST_URI_VLR)
            .AddPair(DMCP_RESOURCE_LIST_NAME, DMCP_RESOURCE_LIST_NAME_VLR)
            .AddPair(DMCP_RESOURCE_LIST_MIME_TYPE, DMCP_RESOURCE_LIST_MIME_TYPE_VLR)
            .AddPair(DMCP_RESOURCE_LIST_DESCRIPTION, DMCP_RESOURCE_LIST_DESCRIPTION_VLR));

          Result.AddPair(DMCP_RESP_SERVER_RESULT, TJSONObject.Create
            .AddPair(DMCP_RESP_SERVER_RESOURCE, lJsonArrayResources));

          TDMCPServer.WriteToLog(DMCP_LOG_CALL_RESOURCE_LIST);
        end;

      DMCP_REQ_METHOD_PROMPT_LIST_IDX:
        begin
          Result.AddPair(DMCP_RESP_SERVER_RESULT, TJSONObject.Create);

          TDMCPServer.WriteToLog(DMCP_LOG_CALL_PROMPTS_LIST);
        end;

      DMCP_REQ_METHOD_NOTIFICATION_INITIALIZED_IDX:
        begin
          FNotReply := True;
          //NOT NECESSARY REPLY
          //Result.AddPair('result', TJSONObject.Create);
          TDMCPServer.WriteToLog(DMCP_LOG_CALL_NOTIFY_INIT);
          Exit;
        end;

      DMCP_REQ_METHOD_TOOLS_CALL_IDX:
        begin
          lRequest := TMCPToolsCall.FromJson(ARequest.ToString);
          try

            if FActions.ContainsKey(lRequest.Params.Name) then
            begin
              lJsonArgument := lRequest.Params.Arguments.ToJson;
              FActions.Items[lRequest.Params.Name](lJsonArgument, lToolsCallResult, lToolsCallError);

              var lResponse := TDMCPCallToolsResponseDTO.Create;
              try
                lResponse.Jsonrpc := lRequest.Jsonrpc;
                lResponse.Id := lRequest.Id;

                if not Assigned(lToolsCallError) then
                begin 
                  lResponse.Result.Free;             
                  lResponse.Result := lToolsCallResult;
                end
                else
                  lResponse.Result.Content.Add(lToolsCallError);

                Result := lResponse.ToJson;  
              finally
                lResponse.Free;
              end;

            end else
              GenerationExceptResponse(DMCP_RESP_SERVER_ERROR_MESSAGE_METHOD_404 + lMethod);
          finally
            lRequest.Free;
          end;          
        end
        else
          GenerationExceptResponse(DMCP_RESP_SERVER_ERROR_MESSAGE_METHOD_404 + lMethod);
    end;
  except
    on E: Exception do
    begin
      TDMCPServer.WriteToLog(DMCP_RESP_SERVER_ERROR +' '+ E.Message);
      GenerationExceptResponse(DMCP_RESP_SERVER_ERROR_MESSAGE_METHOD_500 + E.Message);
    end;
  end;
end;

function GetExceptionStackTrace(E: Exception): string;
{$IFDEF DEBUG}
var
  LTrace: TStringList;
begin
  LTrace := TStringList.Create;
  try
    LTrace.Add(E.StackTrace);
    TDMCPServer.WriteToLog(DMCP_LOG_DEBUG_STACK + LTrace.Text);
    Result := LTrace.Text;
  finally
    LTrace.Free;
  end;
end;
{$ELSE}
begin
  Result := E.Message;
end;
{$ENDIF}


procedure TDMCPServer.Run(AServerInfo: IMCPServerInfos);
var
  lInput, LOutput: TextFile;
  lRequestStr: string;
  lResponseStr: string;
  lResponse,
  lRequest: TJSONObject;
begin
  AssignFile(lInput, '', TEncoding.UTF8.CodePage);
  Reset(lInput);
  AssignFile(LOutput, '');
  Rewrite(LOutput);
  FServerInfo := AServerInfo;
  InitializeCapabilities;
  try
    WriteToLog(DMCP_LOG_SERVER_INIT);

    {$IFDEF MSWINDOWS}
      SetConsoleOutputCP(CP_UTF8);
      SetTextCodePage(Output, CP_UTF8);
      SetConsoleCP(CP_UTF8);
    {$ENDIF};

    while True do
    begin
      if not EOF(lInput) then
      begin
        ReadLn(lInput, lRequestStr);

        WriteToLog(DMCP_LOG_SERVER_RECIVED + lRequestStr);
        try
          lRequest := TJSONObject.ParseJSONValue(lRequestStr) as TJSONObject;
          if Assigned(lRequest) then
          try
            lResponse := ProcessRequest(lRequest);
            if not FNotReply then
            begin
              try
                lResponseStr := TEncoding.UTF8.GetString(TEncoding.ASCII.GetBytes(LResponse.ToString));
                WriteLn(LOutput, lResponseStr);
                Flush(LOutput);
                WriteToLog(DMCP_LOG_SERVER_SENDED + lResponseStr);
                WriteToLog(sLineBreak + sLineBreak);
              finally
                LResponse.Free;
              end;
            end;
          finally
            LRequest.Free;
          end;
        except
          on E: Exception do
            WriteToLog(DMCP_RESP_SERVER_ERROR_MESSAGE_METHOD_500 + E.Message);
        end;
      end
      else
      begin
        Sleep(100);
      end;
    end;
  finally
    CloseFile(lInput);
    CloseFile(LOutput);
    WriteToLog(DMCP_LOG_SERVER_FINALIZED);
  end;
end;

procedure TDMCPServer.SetLogs(AEnabledLogs: Boolean);
begin
  FEnabledLogs := AEnabledLogs;
end;

initialization
  DMCPServer:= TDMCPServer.Create;

finalization
  FreeAndNil(DMCPServer);

end.
