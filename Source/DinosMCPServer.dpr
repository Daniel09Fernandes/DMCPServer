program DinosMCPServer;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  {$IFDEF MSWINDOWS}
  Winapi.Windows,
  {$ENDIF }
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
  D.MCPServer.Consts in 'D.MCPServer.Consts.pas' {/CLient},
  D.MCPServer.Register.Resource.Interf in 'D.MCPServer.Register.Resource.Interf.pas',
  D.MCPServer.Register.Resource in 'D.MCPServer.Register.Resource.pas',
  D.MCPServer.ResourceRead.Model in 'D.MCPServer.ResourceRead.Model.pas',
  D.MCPServer.ResourceRead.Response.Model in 'D.MCPServer.ResourceRead.Response.Model.Pas',
  D.MCPServer.HTTP in 'D.MCPServer.HTTP.pas',
  D.MCPServer.Transport.HTTP.Interf in 'D.MCPServer.Transport.HTTP.Interf.pas';

var lDMCP: IDMCPServerRegister;
 lCallbackGetWeather: TMCPAction;
 lCallbackHelloWorld: TMCPAction;
 lCallbackTest: TMCPAction;
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

       lCallbackTest :=
       procedure(var Params: TJSONObject; out Result: TDMCPCallToolsResult; out Error: TDMCPCallToolsContent)
       begin
         lDMCP.Execute('My name is Daniel', Params, Result, Error,
         procedure
         begin
           {$IFDEF MSWINDOWS}
           MessageBox(0, 'Sayed', 'My name is Daniel', 0);   //callback
           {$ENDIF}
         end);
       end;

    ReportMemoryLeaksOnShutdown := True;

    lDMCP := TDMCPServerRegister.New
      .SetLogs(True);  //Set Logs Request

    lDMCP
      .RegisterAction('get_weather', 'Get current weather information',lCallbackGetWeather)
      .RegisterAction('hello_world', 'opa baum', lCallbackHelloWorld)
      .Protocol(pMcpHTTP)
      .Port('8182')
      .Host('127.0.0.1')
//      .RegisterAction('say_my_name', 'Say my name to user', lCallbackTest)
      .ServerInfo
        .SetServerName('DinosMCPServer')
        .SetVersion('0.1.0')
        .Resources(TMCPServerResources.New
           .SetUri('file:///D:/Documentos/DinosDev-Empresa/Orcamentos/OrcamentoModelo.odt')
           .SetName('Model to create sales order')
           .SetDescription('Standard budget template to be followed for sales orders.'))
        .Tools(TMCPServerTools.New
           .SetName('hello_world')
           .SetDescription('just test')
           .InputSchema
              .SetType(ptObject)
              .SetAdditionalProperties(False)
           .&End)
        .Tools(TMCPServerTools.New
          .SetName('get_weather')
          .InputSchema
             .SetType(ptObject)
             .SetProperties('location', ptString, 'Location to get weather')
             .SetProperties('Conditions', ptString, 'weather conditions')
             .SetProperties('EnableLog', ptBoolean, 'if you need save log to this requeste')
             .SetRequired(['location'])
             .SetAdditionalProperties(False)
          .&End)
//         .Tools(TMCPServerTools.New
//           .SetName('say_my_name')
//           .SetDescription('Say my name to user, when him quest')
//           .InputSchema
//              .SetType(ptObject)
//              .SetAdditionalProperties(False)
//           .&End)
                        ;
    lDMCP.Run;
  except
    on E: Exception do
       TDMCPServer.WriteToLog('Error: '+ E.ClassName+ ': '+ E.Message);
  end;
end.
