unit D.MCPServer.Registers.Actions.Interf;

interface

uses
    System.JSON, System.IOUtils, Rest.Json,
    System.SysUtils,
    System.Generics.Collections,
    D.MCPServer.ToolsCall.Model,
    D.MCPServer.ToolsCall.Response.Model,
    D.MCPServer.Registers.Interf,
    D.MCPServer.Registers.Tools.Interf;

type
   TMCPAction = reference to procedure(var Params: TJSONObject; out Result: TDMCPCallToolsResult; out Error: TDMCPCallToolsContent);

   IDMCPServerRegister = interface
   ['{F07BD31B-CDD6-4EDA-8F63-1123DC028790}']

    function RegisterAction(const ActionName, ActionDescription: string; const ActionProc: TMCPAction): IDMCPServerRegister;
    function ServerInfo: IMCPServerInfos;
    function Required: TDictionary<string, IMCPServerToolsSchemaTypes>;
    function SetLogs(AEnabledLogs: Boolean): IDMCPServerRegister;
    function Execute(AStringResponse: string; var AParams: TJSONObject; var AResult: TDMCPCallToolsResult; var AError: TDMCPCallToolsContent; AExecute: TProc): IDMCPServerRegister;

    procedure Run;
   end;

implementation

end.
