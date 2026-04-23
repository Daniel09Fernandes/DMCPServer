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

{ File     : D.MCPServer.Register.Prompt.pas }
{ Developer: Daniel Fernandes Rodrigures }
{ Email    : danielfernandesroddrigues@gmail.com }
{ this unit is a part of the Open Source. }
{ licensed under a MIT - see LICENSE.md}

{ ******************************************************* }

unit D.MCPServer.Register.Prompt;

interface

uses
  System.Generics.Collections,
  D.MCPServer.Register.Prompt.Interf;

type
  TMCPServerPromptArgument = class(TInterfacedObject, IMCPServerPromptArgument)
  private
    FName: string;
    FDescription: string;
    FRequired: Boolean;
  public
    function SetName(AName: string): IMCPServerPromptArgument;
    function GetName: string;
    function SetDescription(ADescription: string): IMCPServerPromptArgument;
    function GetDescription: string;
    function SetRequired(ARequired: Boolean): IMCPServerPromptArgument;
    function GetRequired: Boolean;

    class function New: IMCPServerPromptArgument;
  end;

  TMCPServerPrompts = class(TInterfacedObject, IMCPServerPrompts)
  private
    FName: string;
    FDescription: string;
    FArguments: TList<IMCPServerPromptArgument>;
  public
    constructor Create;
    destructor Destroy; override;

    function SetName(AName: string): IMCPServerPrompts;
    function GetName: string;
    function SetDescription(ADescription: string): IMCPServerPrompts;
    function GetDescription: string;
    function AddArgument(AArg: IMCPServerPromptArgument): IMCPServerPrompts;
    function GetArguments: TList<IMCPServerPromptArgument>;

    class function New: IMCPServerPrompts;
  end;

implementation

{ TMCPServerPromptArgument }

class function TMCPServerPromptArgument.New: IMCPServerPromptArgument;
begin
  Result := TMCPServerPromptArgument.Create;
end;

function TMCPServerPromptArgument.GetDescription: string;
begin
  Result := FDescription;
end;

function TMCPServerPromptArgument.GetName: string;
begin
  Result := FName;
end;

function TMCPServerPromptArgument.GetRequired: Boolean;
begin
  Result := FRequired;
end;

function TMCPServerPromptArgument.SetDescription(ADescription: string): IMCPServerPromptArgument;
begin
  FDescription := ADescription;
  Result := Self;
end;

function TMCPServerPromptArgument.SetName(AName: string): IMCPServerPromptArgument;
begin
  FName := AName;
  Result := Self;
end;

function TMCPServerPromptArgument.SetRequired(ARequired: Boolean): IMCPServerPromptArgument;
begin
  FRequired := ARequired;
  Result := Self;
end;

{ TMCPServerPrompts }

constructor TMCPServerPrompts.Create;
begin
  inherited;
  FArguments := TList<IMCPServerPromptArgument>.Create;
end;

destructor TMCPServerPrompts.Destroy;
begin
  FArguments.Free;
  inherited;
end;

class function TMCPServerPrompts.New: IMCPServerPrompts;
begin
  Result := TMCPServerPrompts.Create;
end;

function TMCPServerPrompts.GetArguments: TList<IMCPServerPromptArgument>;
begin
  Result := FArguments;
end;

function TMCPServerPrompts.GetDescription: string;
begin
  Result := FDescription;
end;

function TMCPServerPrompts.GetName: string;
begin
  Result := FName;
end;

function TMCPServerPrompts.SetDescription(ADescription: string): IMCPServerPrompts;
begin
  FDescription := ADescription;
  Result := Self;
end;

function TMCPServerPrompts.SetName(AName: string): IMCPServerPrompts;
begin
  FName := AName;
  Result := Self;
end;

function TMCPServerPrompts.AddArgument(AArg: IMCPServerPromptArgument): IMCPServerPrompts;
begin
  Result := Self;
  if Assigned(AArg) then
    FArguments.Add(AArg);
end;

end.
