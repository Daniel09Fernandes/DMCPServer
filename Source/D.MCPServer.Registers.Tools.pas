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

{ File     : D.MCPServer.Registers.Tools.pas }
{ Developer: Daniel Fernandes Rodrigures }
{ Email    : danielfernandesroddrigues@gmail.com }
{ this unit is a part of the Open Source. }
{ licensed under a MIT - see LICENSE.md}

{ ******************************************************* }

unit D.MCPServer.Registers.Tools;

interface

uses
  System.Generics.Collections,
  D.MCPServer.Registers.Tools.Interf;

type
  THelperPropType = record helper for TProType
    function ToString: string;
  end;

  TMCPSchema = TDictionary<string, IMCPServerToolsSchemaTypes>;

  TMCPServerToolsSchemaTypes = class(TInterfacedObject, IMCPServerToolsSchemaTypes)
  private
//    FISchema: IMCPServerToolsSchema;
    FPropType: TProType;
    FDescription: string;
    FFormat: string;
    constructor Create;
  public
    function GetPropType: TProType;
    function SetPropType(APropType: TProType): IMCPServerToolsSchemaTypes;
    function GetDescription: string;
    function SetDescription(AValue: string): IMCPServerToolsSchemaTypes;
    function GetFormat: string;
    function SetFormat(AValue: TProType): IMCPServerToolsSchemaTypes;

    class function New: IMCPServerToolsSchemaTypes;
  end;

  TMCPServerToolsSchema = class(TInterfacedObject, IMCPServerToolsSchema)
  private
    FProperties: TMCPSchema;
    FToolsSchemaTypes: IMCPServerToolsSchemaTypes;
    FType: TProType;
    FRequired: TArray<string>;
    FAdditionalProperties: Boolean;
    FMCPServerTools: IMCPServerTools;
    constructor Create(AMCPServerTools: IMCPServerTools);
  public
    function GetType: TProType;
    function SetType(AType: TProType): IMCPServerToolsSchema;
    function GetProperties: TMCPSchema;
    function SetProperties(AKey: string; AType: TProType = ptString; ADescription: string = ''; AFormat: TProType = ptText): IMCPServerToolsSchema;
    function GetRequired: TArray<string>;
    function SetRequired(ARequireds: TArray<string>): IMCPServerToolsSchema;
    function GetAdditionalProperties: Boolean;
    function SetAdditionalProperties(AValue: Boolean): IMCPServerToolsSchema;
    function ToolsSchemaTypes: IMCPServerToolsSchemaTypes;
    function &End: IMCPServerTools;

    class function New(AMCPServerTools: IMCPServerTools): IMCPServerToolsSchema;
    destructor Destroy; override;
  end;

  TMCPServerTools = class(TInterfacedObject, IMCPServerTools)
  private
    FToolsName: string;
    FToolsDescription: string;
    FInputSchema: IMCPServerToolsSchema;
    constructor Create;
  public
    function GetName: string;
    function SetName(ANameTools: string): IMCPServerTools;
    function SetDescription(AToolsDescription: string): IMCPServerTools;
    function GetDescription: string;
    function InputSchema: IMCPServerToolsSchema;

    class function New: IMCPServerTools;
  end;

implementation

{ TMCPServerTools }

constructor TMCPServerTools.Create;
begin
  FInputSchema := TMCPServerToolsSchema.New(Self);
//  TMCPServerToolsSchema.FIMCPServerTools := self;
//  TMCPServerToolsSchemaTypes.FISchema := TMCPServerToolsSchema.New;
end;

function TMCPServerToolsSchema.GetAdditionalProperties: Boolean;
begin
  Result := FAdditionalProperties;
end;

function TMCPServerTools.GetDescription: string;
begin
  Result := FToolsDescription;
end;

function TMCPServerTools.GetName: string;
begin
  Result := FToolsName;
end;

function TMCPServerToolsSchema.GetRequired: TArray<string>;
begin
  Result := FRequired;
end;

function TMCPServerTools.InputSchema: IMCPServerToolsSchema;
begin
  Result := FInputSchema;
end;

class function TMCPServerTools.New: IMCPServerTools;
begin
  Result := TMCPServerTools.Create;
end;

function TMCPServerToolsSchema.SetAdditionalProperties(AValue: Boolean): IMCPServerToolsSchema;
begin
  FAdditionalProperties := AValue;
  Result := Self;
end;

function TMCPServerTools.SetDescription(AToolsDescription: string): IMCPServerTools;
begin
  FToolsDescription := AToolsDescription;
  Result := Self;
end;

function TMCPServerTools.SetName(ANameTools: string): IMCPServerTools;
begin
  FToolsName := ANameTools;
  Result := Self;
end;

function TMCPServerToolsSchema.SetRequired(ARequireds: TArray<string>): IMCPServerToolsSchema;
begin
  FRequired := FRequired + ARequireds;
  Result := Self;
end;

{ TMCPServerToolsSchema }

constructor TMCPServerToolsSchema.Create(AMCPServerTools: IMCPServerTools);
begin
  FProperties := TMCPSchema.Create;
  FToolsSchemaTypes := TMCPServerToolsSchemaTypes.New;
  FMCPServerTools := AMCPServerTools;
end;

destructor TMCPServerToolsSchema.Destroy;
begin
  FProperties.Free;
end;

function TMCPServerToolsSchema.&End: IMCPServerTools;
begin
  Result := FMCPServerTools;
end;

function TMCPServerToolsSchema.GetProperties: TMCPSchema;
begin
  Result := FProperties;
end;

function TMCPServerToolsSchema.GetType: TProType;
begin
  Result := FType;
end;

class function TMCPServerToolsSchema.New(AMCPServerTools: IMCPServerTools): IMCPServerToolsSchema;
begin
  Result :=  TMCPServerToolsSchema.Create(AMCPServerTools);
end;

function TMCPServerToolsSchema.SetProperties(AKey: string; AType: TProType = ptString; ADescription: string = ''; AFormat: TProType = ptText): IMCPServerToolsSchema;
var
  lSchema: IMCPServerToolsSchemaTypes;
begin
  lSchema := TMCPServerToolsSchemaTypes.New;
  lSchema.SetPropType(AType);
  lSchema.SetDescription(ADescription);
  lSchema.SetFormat(AFormat);

  FProperties.Add(AKey, lSchema);
  Result := Self;
end;

function TMCPServerToolsSchema.SetType(AType: TProType): IMCPServerToolsSchema;
begin
  FType := AType;
  Result := Self;
end;

function TMCPServerToolsSchema.ToolsSchemaTypes: IMCPServerToolsSchemaTypes;
begin
  Result := FToolsSchemaTypes;
end;

{ TMCPServerToolsSchemaTypes }

constructor TMCPServerToolsSchemaTypes.Create;
begin

end;

function TMCPServerToolsSchemaTypes.GetDescription: string;
begin
  Result := FDescription;
end;

function TMCPServerToolsSchemaTypes.GetFormat: string;
begin
  Result := FFormat;
end;

function TMCPServerToolsSchemaTypes.GetPropType: TProType;
begin
  Result := FPropType;
end;

class function TMCPServerToolsSchemaTypes.New: IMCPServerToolsSchemaTypes;
begin
  Result := TMCPServerToolsSchemaTypes.Create;
end;

function TMCPServerToolsSchemaTypes.SetDescription(AValue: string): IMCPServerToolsSchemaTypes;
begin
  FDescription := AValue;
  Result := Self;
end;

function TMCPServerToolsSchemaTypes.SetFormat(AValue: TProType): IMCPServerToolsSchemaTypes;
begin
  FFormat := AValue.ToString;
  Result := Self;
end;

function TMCPServerToolsSchemaTypes.SetPropType(APropType: TProType): IMCPServerToolsSchemaTypes;
begin
  FPropType := APropType;
  Result := Self;
end;

{ THelperPropType }

function THelperPropType.ToString: string;
begin
  case Self of
    ptString:
      Result := 'string';
    ptText:
      Result := 'text';
    ptInteger:
      Result := 'number';
    ptDouble:
      Result := 'number';
    ptJson:
      Result := 'json';
    ptObject:
      Result := 'object';
    ptArray:
      Result := 'array';
    ptBoolean:
      Result := 'boolean';
    ptDate:
      Result := 'date';
  end;
end;

end.
