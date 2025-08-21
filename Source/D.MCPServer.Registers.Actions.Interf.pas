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

{ File     : D.MCPServer.Registers.Actions.Interf.pas }
{ Developer: Daniel Fernandes Rodrigures }
{ Email    : danielfernandesroddrigues@gmail.com }
{ this unit is a part of the Open Source. }
{ licensed under a MIT - see LICENSE.md}

{ ******************************************************* }
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
