<p align="left">
  <a href="https://github.com/Daniel09Fernandes/DMCPServer/blob/main/img/DMCPServer.png">
    <img alt="DMCPServer" height="200" src="https://github.com/Daniel09Fernandes/DMCPServer/blob/main/img/DMCPServer.png">
  </a>  
</p><br>
<p align="left">
  <b>Transform your Delphi code on MCPServer wih DMCPServer.</b>
</p><br>

## 🎯 About
DMCPServer is a master control protocol server developed in Delphi.

## ⚙️ Installation
Installation is done using the [`boss install`](https://github.com/HashLoad/boss) command:
``` sh
boss install github.com/Daniel09Fernandes/DMCPServer
```

## 🚀 Register your Action
``` pascal
var     
  lCallbackGetWeather : TMCPAction;
begin
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
end;
```

## 📋 Create and register your server informations
``` pascal
var     
   lDMCP: IDMCPServerRegister;
begin
   lDMCP := TDMCPServerRegister.New
      .SetLogs(True);  //Set Logs Request

    lDMCP
      .RegisterAction('get_weather', 'Get current weather information', lCallbackGetWeather)     
      .ServerInfo
      .SetServerName('DinosMCPServer')
      .SetVersion('0.1.0')        
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
end;
```

# Documentation
 
📖 Read the complete documentation here:  [DMCPServer-docs](https://dmcpserver-doc.lovestoblog.com/)



