program DinosMCPServer;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  {$IFDEF MSWINDOWS}
    Winapi.Windows,
  {$ENDIF}
  System.SysUtils,
  System.json,
  D.MCPServer.STDIO in 'D.MCPServer.STDIO.pas',
  D.MCPServer.ToolsCall.Model in 'D.MCPServer.ToolsCall.Model.pas',
  D.MCPServer.ToolsCall.Response.Model in 'D.MCPServer.ToolsCall.Response.Model.Pas',
  D.MCPServer.Registers in 'D.MCPServer.Registers.pas',
  D.MCPServer.Registers.Interf in 'D.MCPServer.Registers.Interf.pas',
  D.MCPServer.Registers.Tools.Interf in 'D.MCPServer.Registers.Tools.Interf.pas',
  D.MCPServer.Registers.Tools in 'D.MCPServer.Registers.Tools.pas',
  D.MCPServer.Registers.Actions.Interf in 'D.MCPServer.Registers.Actions.Interf.pas',
  D.MCPServer.Registers.Actions in 'D.MCPServer.Registers.Actions.pas',
  D.MCPServer.Consts in 'D.MCPServer.Consts.pas';

var lDMCP: IDMCPServerRegister;
 lCallbackGetWeather: TMCPAction;
 lCallbackHelloWorld: TMCPAction;
begin
  try
    //you can use that (TProc)
    lCallbackGetWeather :=
       procedure(var Params: TJSONObject; out Result: TDMCPCallToolsResult; out Error: TDMCPCallToolsContent)
       begin
         lDMCP.Execute('Temperatura em '+ Params.GetValue('location').Value + ' e está ensolarado', Params, Result, Error,
         procedure
         begin
           {$IFDEF MSWINDOWS}
           MessageBox(0, 'get_weather on execute', 'DinosDev', 0);  //callback
           {$ENDIF}
         end);
       end;

    // Otherwise (TMCPAction, you control memory )
    lCallbackHelloWorld :=
       procedure(var Params: TJSONObject; out Result: TDMCPCallToolsResult; out Error: TDMCPCallToolsContent)
       begin
         lDMCP.Execute('Salve meu Claude, baum?', Params, Result, Error,
         procedure
         begin
           {$IFDEF MSWINDOWS}
           MessageBox(0, 'Hello World', 'DinosDev', 0);   //callback
           {$ENDIF}
         end);
       end;

    ReportMemoryLeaksOnShutdown := True;

    lDMCP := TDMCPServerRegister.New
      .SetLogs(True);  //Set Logs Request

    lDMCP
      .RegisterAction('get_weather', 'Get current weather information',lCallbackGetWeather)
      .RegisterAction('hello_world', 'opa baum', lCallbackHelloWorld)
      .ServerInfo
      .SetServerName('DinosMCPServer')
      .SetVersion('0.1.0')
        .Tools(TMCPServerTools.New
           .SetName('hello_world')
           .InputSchema
              .SetType(ptObject)
              .SetAdditionalProperties(False)
           .&End)
        .Tools(TMCPServerTools.New
          .SetName('get_weather')
          .InputSchema
             .SetType(ptObject)
             .SetProperties('location', ptString)
             .SetProperties('Conditions', ptString)
             .SetProperties('EnableLog', ptBoolean)
             .SetRequired(['location'])
             .SetAdditionalProperties(False)
          .&End);
    lDMCP.Run;
  except
    on E: Exception do
       TDMCPServer.WriteToLog('Error: '+ E.ClassName+ ': '+ E.Message);
  end;
end.
