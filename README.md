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

## Attach on Claude AI

Access the configuration on developer and edit config

<img width="364" height="167" alt="image" src="https://github.com/user-attachments/assets/b0e1d02c-3806-49ec-81a2-b1bef521e93b" /><br>


<img width="945" height="685" alt="image" src="https://github.com/user-attachments/assets/5cdc6748-6437-4ed6-84ff-e8cfe8502de3" /><br>


In mcpServers node, attach your MCPServer


<img width="713" height="283" alt="image" src="https://github.com/user-attachments/assets/8af35f54-3042-4004-9385-50b0eda76b4a" /><br>



# Documentation
 
📖 Read the complete documentation here:  [DMCPServer-docs](https://dmcpserver-doc.lovestoblog.com/)



