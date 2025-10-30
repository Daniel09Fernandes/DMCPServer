{ MIT License

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
  SOFTWARE. }
{ ******************************************************* }

{ DMCP Library }

{ File     : D.MCPServer.Registers.Resource.pas }
{ Developer: Daniel Fernandes Rodrigures }
{ Email    : danielfernandesroddrigues@gmail.com }
{ this unit is a part of the Open Source. }
{ licensed under a MIT - see LICENSE.md }

{ ******************************************************* }

unit D.MCPServer.Register.Resource;

interface

uses
  D.MCPServer.Register.Resource.Interf;

type
  TMCPServerResources = class(TInterfacedObject, IMCPServerResources)
  private
    FUri: string;
    FName: string;
    FDescription: string;
    FMimeType: string;

  public
    /// <summary> To insert a file path, enter it like this: "file:///C:/Timesheets/outubro_2025.xlsx"
    /// </summary>
    function SetUri(AFileUri: string): IMCPServerResources;
    function GetUri: string;
    function SetName(AName: string): IMCPServerResources;
    function GetName: string;
    function SetDescription(ADescription: string): IMCPServerResources;
    function GetDescription: string;
    function SetMimeType(AMimeType: string): IMCPServerResources;
    function GetMimeType: string;

    class function New: IMCPServerResources;
  end;

implementation

{ TMCPServerResources }

function TMCPServerResources.GetDescription: string;
begin
  Result := FDescription;
end;

function TMCPServerResources.GetMimeType: string;
begin
  Result := FMimeType;
end;

function TMCPServerResources.GetName: string;
begin
  Result := FName;
end;

function TMCPServerResources.GetUri: string;
begin
  Result := FUri;
end;

class function TMCPServerResources.New: IMCPServerResources;
begin
  Result := TMCPServerResources.Create;
end;

function TMCPServerResources.SetDescription(ADescription: string): IMCPServerResources;
begin
  FDescription := ADescription;
  Result := Self;
end;

function TMCPServerResources.SetMimeType(AMimeType: string): IMCPServerResources;
begin
  FMimeType := AMimeType;
  Result := Self;
end;

function TMCPServerResources.SetName(AName: string): IMCPServerResources;
begin
  FName := AName;
  Result := Self;
end;

function TMCPServerResources.SetUri(AFileUri: string): IMCPServerResources;
begin
  FUri := AFileUri;
  Result := Self;
end;

end.
