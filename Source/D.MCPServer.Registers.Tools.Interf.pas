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

{ File     : D.MCPServer.Registers.Tools.Interf.pas }
{ Developer: Daniel Fernandes Rodrigures }
{ Email    : danielfernandesroddrigues@gmail.com }
{ this unit is a part of the Open Source. }
{ licensed under a MIT - see LICENSE.md}

{ ******************************************************* }

unit D.MCPServer.Registers.Tools.Interf;

interface

Uses System.Generics.Collections;

type
  TProType = (ptString, ptInteger, ptDouble, ptJson, ptObject, ptArray, ptText, ptBoolean, ptDate);

  IMCPServerTools = interface;
  IMCPServerToolsSchema = interface;

  IMCPServerToolsSchemaTypes = interface
    ['{1CF46AD8-9B6C-4360-BD0F-6CFB5D12C228}']

    function GetPropType: TProType;
    function SetPropType(APropType: TProType): IMCPServerToolsSchemaTypes;
    function GetDescription: string;
    function SetDescription(AValue: string): IMCPServerToolsSchemaTypes;
    function GetFormat: string;
    function SetFormat(AValue: TProType): IMCPServerToolsSchemaTypes;
  end;

  IMCPServerToolsSchema = interface
    ['{6134FEEE-6D25-474A-8B6A-C4A6FC85AF52}']

    function GetType: TProType;
    function SetType(AType: TProType): IMCPServerToolsSchema;
    function GetProperties: TDictionary<string, IMCPServerToolsSchemaTypes>;
    function SetProperties(AKey: string; AType: TProType = ptString; ADescription: string = ''; AFormat: TProType = ptText): IMCPServerToolsSchema;
    function GetRequired: TArray<string>;
    function SetRequired(ARequireds: TArray<string>): IMCPServerToolsSchema;
    function GetAdditionalProperties: Boolean;
    function SetAdditionalProperties(AValue: Boolean): IMCPServerToolsSchema;
    function ToolsSchemaTypes: IMCPServerToolsSchemaTypes;
    function &End: IMCPServerTools;
  end;

  IMCPServerTools = interface
    ['{EF374254-E692-4932-811A-F27785261A6B}']

    function GetName: string;
    function SetName(ANameTools: string): IMCPServerTools;
    function SetDescription(AToolsDescription: string): IMCPServerTools;
    function GetDescription: string;
    function InputSchema: IMCPServerToolsSchema;
  end;

implementation

end.
