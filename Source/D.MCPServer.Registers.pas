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

{ File     : D.MCPServer.Registers.pas }
{ Developer: Daniel Fernandes Rodrigures }
{ Email    : danielfernandesroddrigues@gmail.com }
{ this unit is a part of the Open Source. }
{ licensed under a MIT - see LICENSE.md}

{ ******************************************************* }
unit D.MCPServer.Registers;

interface

uses
  System.Generics.Collections,
  D.MCPServer.Registers.Interf,
  D.MCPServer.Registers.Tools.Interf,
  D.MCPServer.Register.Resource.Interf;

type
  TDMCPRegisters = class(TInterfacedObject, IMCPServerInfos)
  private
    FServerName: string;
    FServerVersion: string;
    FITools: TList<IMCPServerTools>;
    FIResource: TList<IMCPServerResources>;

    procedure Initialize;
    procedure Finalize;
  public
    constructor Create;
    destructor Destroy; override;

    function SetServerName(AServerName: string): IMCPServerInfos;
    function GetServerName: string;
    function SetVersion(AServerVersion: string): IMCPServerInfos;
    function GetVersion: string;

    function Tools: TList<IMCPServerTools>; overload;
    function Tools(ATool: IMCPServerTools): IMCPServerInfos; overload;
    function Resources(AResource: IMCPServerResources): IMCPServerInfos; overload;
    function Resources: TList<IMCPServerResources>; overload;

    class function New: IMCPServerInfos;
  end;

implementation

{ TDMCPRegisters }

constructor TDMCPRegisters.Create;
begin
  inherited;
  Initialize;
end;

destructor TDMCPRegisters.Destroy;
begin
  Finalize;
  inherited;
end;

procedure TDMCPRegisters.Initialize;
begin
  FITools := TList<IMCPServerTools>.Create;
  FIResource := TList<IMCPServerResources>.Create;
  FServerName := '';
  FServerVersion := '';
end;

procedure TDMCPRegisters.Finalize;
begin
  if Assigned(FITools) then
    FITools.Free;

  if Assigned(FIResource) then
    FIResource.Free;
end;

class function TDMCPRegisters.New: IMCPServerInfos;
begin
  Result := TDMCPRegisters.Create;
end;

function TDMCPRegisters.Resources: TList<IMCPServerResources>;
begin
  Result := FIResource;
end;

function TDMCPRegisters.GetServerName: string;
begin
  Result := FServerName;
end;

function TDMCPRegisters.GetVersion: string;
begin
  Result := FServerVersion;
end;

function TDMCPRegisters.SetServerName(AServerName: string): IMCPServerInfos;
begin
  Result := Self;
  FServerName := AServerName;
end;

function TDMCPRegisters.SetVersion(AServerVersion: string): IMCPServerInfos;
begin
  Result := Self;
  FServerVersion := AServerVersion;
end;

function TDMCPRegisters.Tools: TList<IMCPServerTools>;
begin
  Result := FITools;
end;

function TDMCPRegisters.Tools(ATool: IMCPServerTools): IMCPServerInfos;
begin
  Result := Self;

  if Assigned(ATool) then
    FITools.Add(ATool);
end;

function TDMCPRegisters.Resources(AResource: IMCPServerResources): IMCPServerInfos;
begin
  Result := Self;

  if Assigned(AResource) then
    FIResource.Add(AResource);
end;

end.
