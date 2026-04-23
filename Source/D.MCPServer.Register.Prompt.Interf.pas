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

{ File     : D.MCPServer.Register.Prompt.Interf.pas }
{ Developer: Daniel Fernandes Rodrigures }
{ Email    : danielfernandesroddrigues@gmail.com }
{ this unit is a part of the Open Source. }
{ licensed under a MIT - see LICENSE.md}

{ ******************************************************* }

unit D.MCPServer.Register.Prompt.Interf;

interface

uses
  System.Generics.Collections;

type
  IMCPServerPromptArgument = interface
    ['{A1B2C3D4-1111-4AAA-BBBB-000000000001}']

    function SetName(AName: string): IMCPServerPromptArgument;
    function GetName: string;
    function SetDescription(ADescription: string): IMCPServerPromptArgument;
    function GetDescription: string;
    function SetRequired(ARequired: Boolean): IMCPServerPromptArgument;
    function GetRequired: Boolean;
  end;

  IMCPServerPrompts = interface
    ['{A1B2C3D4-2222-4AAA-BBBB-000000000002}']

    function SetName(AName: string): IMCPServerPrompts;
    function GetName: string;
    function SetDescription(ADescription: string): IMCPServerPrompts;
    function GetDescription: string;
    function AddArgument(AArg: IMCPServerPromptArgument): IMCPServerPrompts;
    function GetArguments: TList<IMCPServerPromptArgument>;
  end;

implementation

end.
