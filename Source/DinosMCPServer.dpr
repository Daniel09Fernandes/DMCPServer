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

 type
  IWeatherService = interface
    function GetWeatherData(const Location: string): string;
  end;

  type
  TMockWeatherService = class(TInterfacedObject, IWeatherService)
  public
    function GetWeatherData(const Location: string): string;
  end;

{ TMockWeatherService }

function TMockWeatherService.GetWeatherData(const Location: string): string;
var
  Temperature: Integer;
  Condition: string;
  Humidity: Integer;
begin
  // radom data
  Temperature := Random(31) + 5; // 5-35°C
  case Random(4) of
    0: Condition := 'Ensolarado';
    1: Condition := 'Nublado';
    2: Condition := 'Chuvoso';
    3: Condition := 'Parcialmente Nublado';
  end;
  Humidity := Random(40) + 40; // 40-80%

  Result := Format('{"location": "%s", "temperature": %d, "condition": "%s", "humidity": %d, "timestamp": "%s"}',
    [Location, Temperature, Condition, Humidity, FormatDateTime('yyyy-mm-dd hh:nn:ss', Now)]);
end;

begin
  try
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
              Location := Params.GetParam('location');
              EnableLog := Params.GetParam('EnableLog', trBool);

              if Location.Trim = '' then
                raise Exception.Create('Location parameter is required');

              WeatherService := TMockWeatherService.Create;
              WeatherData := WeatherService.GetWeatherData(Location);


              if EnableLog then
                TDMCPServer.WriteToLog(Format('Weather data requested for %s', [Location]));

              Result := TDMCPCallToolsResult.Create;
              Result.Content.AddRange(TDMCPCallToolsContent.Create(ptText, WeatherData));

              Error := nil;
            finally
              Params.Free;
            end;
         except
            on E: Exception do
            begin

              Error := TDMCPCallToolsContent.Create(ptText,
                'Weather service error: ' + E.Message);
              TDMCPServer.WriteToLog('Error in get_weather: ' + E.Message);
              Result := nil;
            end;
         end;
        end;

    ReportMemoryLeaksOnShutdown := True;

    lDMCP := TDMCPServerRegister.New
      .SetLogs(False);  //Set Logs Request

    lDMCP
      .RegisterAction('get_weather', 'Get weather information, such as the latest weather forecast.', lCallbackGetWeather)
      .Protocol(pMcpHTTP)  //To Run Local use pMcpSTIO
      .Port('8182')  //No Need to pMcpSTIO
      .Host('127.0.0.1') //No Need to pMcpSTIO
      .ServerInfo
        .SetServerName('DinosMCPServer')
        .SetVersion('0.1.0')
        .Resources(TMCPServerResources.New
           .SetUri('file:///'+ ParamStr(0).Replace('\','/') + '/Resource_teste/Resource.txt')
           .SetName('weather forecasting works.')
           .SetDescription('Explanation of how weather forecasting works.'))
        .Tools(TMCPServerTools.New
          .SetName('get_weather')  //Same name the RegisterAction
          .InputSchema
             .SetType(ptObject)
             .SetProperties('location', ptString, 'Location to get weather')
             .SetProperties('EnableLog', ptBoolean, 'if you need save log to this requeste')
             .SetRequired(['location'])
             .SetAdditionalProperties(False)
          .&End);
    lDMCP.Run;
  except
    on E: Exception do
       TDMCPServer.WriteToLog('Error: '+ E.ClassName+ ': '+ E.Message);
  end;
end.
