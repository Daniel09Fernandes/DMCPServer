Dinos MCPServer - Version 1.0.1
---

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

## ⚙️ Protocol

| Protocol   | Supported 	|
|----------- |-----------	|
| HTTP 	     |    ✅ 	  |
| STDIO    	 |    ✅ 	  |


## 🚀 Register your Action
``` pascal
var     
  lCallbackGetWeather : TMCPAction;
begin
 lCallbackGetWeather :=
       procedure(var Params: TJSONObject; out Result: TDMCPCallToolsResult; out Error: TDMCPCallToolsContent)
       var
         Location: string;
         EnableLog: Boolean;
         WeatherService: IWeatherService;
         WeatherData: string;
       begin
         try
            try
              // Extract parameters
              Location := Params.GetParam('location');
              EnableLog := Params.GetParam('EnableLog', trBool);

              // Validation of required parameters
              if Location.Trim = '' then
                raise Exception.Create('Location parameter is required');

              WeatherService := TMockWeatherService.Create;
              WeatherData := WeatherService.GetWeatherData(Location);


              if EnableLog then
                TDMCPServer.WriteToLog(Format('Weather data requested for %s', [Location]));

              // Assemble the result - There's no need to release it from memory; it's done automatically.
              Result := TDMCPCallToolsResult.Create;
              Result.Content.AddRange(TDMCPCallToolsContent.Create(ptText, WeatherData));

              Error := nil;
            finally
              Params.Free;
            end;
         except
            on E: Exception do
            begin
              // Handles exceptions. to MCPServers Defaults
              Error := TDMCPCallToolsContent.Create(ptText,
                'Weather service error: ' + E.Message);
              TDMCPServer.WriteToLog('Error in get_weather: ' + E.Message);
              Result := nil;
            end;
         end;
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

<img width="40" height="40" alt="image" src="https://github.com/user-attachments/assets/1e00baca-3bf2-4895-b1a1-1dcc04f90195" />  To add more resources to LLM memories for use with MCP
```pascal
 .ServerInfo
        .SetServerName('DinosMCPServer')
        .SetVersion('0.1.0')
        .Resources(TMCPServerResources.New
           .SetUri('file:///C:/Users/danie/Downloads/teste/fatura-exemplo.csv')
           .SetName('Model to create sales order')
           .SetDescription('Standard budget template to be followed for sales orders.'))
```

## Attach on Claude AI

Access the configuration on developer and edit config

<img width="364" height="167" alt="image" src="https://github.com/user-attachments/assets/b0e1d02c-3806-49ec-81a2-b1bef521e93b" /><br>


<img width="945" height="685" alt="image" src="https://github.com/user-attachments/assets/5cdc6748-6437-4ed6-84ff-e8cfe8502de3" /><br>


In mcpServers node, attach your MCPServer(STDIO)


<img width="713" height="283" alt="image" src="https://github.com/user-attachments/assets/8af35f54-3042-4004-9385-50b0eda76b4a" /><br>

To HTTP: 

<img width="398" height="604" alt="image" src="https://github.com/user-attachments/assets/fb4f3cb4-16e6-4908-ac57-44d1a1f76f87" />



# Documentation
 
📖 Read the complete documentation here:  [DMCPServer-docs](https://dmcpserver-doc.lovestoblog.com/)

🎬 Watch on Youtube [DMCPServer - PT-BR](https://www.youtube.com/watch?v=AAv67r8OuWo&feature=youtu.be)  

🎬 Watch on Youtube, Full explanation of MCP [DMCPServer - EN-US](https://www.youtube.com/live/a5-xjUtc-CA?si=gQAIhJKf3nY4WE-z&t=4623)   

---

### O componente é totalmente free, se ele foi muito útil para você, que tal me pagar um café para incentivar o projeto?

PIX:

<img src="https://github.com/Daniel09Fernandes/ComponentDinosOffice-OpenOffice/assets/29381329/00dcc168-df75-4228-b80d-7262c7b4c478" width="300" height="300">


## Star History

[![Star History Chart](https://api.star-history.com/svg?repos=daniel09fernandes/DMCPServer&type=date&legend=top-left)](https://www.star-history.com/#daniel09fernandes/DMCPServer&type=date&legend=top-left)


