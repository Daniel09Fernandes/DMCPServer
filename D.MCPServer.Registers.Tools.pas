unit D.MCPServer.Registers.Tools;

interface

uses
  System.Generics.Collections,
  D.MCPServer.Registers.Tools.Interf;

type
  THelperPropType = record helper for TProType
    function ToString: string;
  end;

  TMCPSchema = TDictionary<string, TProType>;

  TMCPServerToolsSchemaTypes = class(TInterfacedObject, IMCPServerToolsSchemaTypes)
  private
    FISchema: IMCPServerToolsSchema;
    FPropType: TProType;
    constructor Create;
  public
    function GetPropType: TProType;
    function SetPropType(APropType: TProType): IMCPServerToolsSchemaTypes;

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
    destructor Destroy;
  public
    function GetType: TProType;
    function SetType(AType: TProType): IMCPServerToolsSchema;
    function GetProperties: TMCPSchema;
    function SetProperties(AKey: string; AValue: TProType): IMCPServerToolsSchema;
    function GetRequired: TArray<string>;
    function SetRequired(ARequireds: TArray<string>): IMCPServerToolsSchema;
    function GetAdditionalProperties: Boolean;
    function SetAdditionalProperties(AValue: Boolean): IMCPServerToolsSchema;
    function ToolsSchemaTypes: IMCPServerToolsSchemaTypes;
    function &End: IMCPServerTools;

    class function New(AMCPServerTools: IMCPServerTools): IMCPServerToolsSchema;
  end;

  TMCPServerTools = class(TInterfacedObject, IMCPServerTools)
  private
    FToolsName: string;
    FInputSchema: IMCPServerToolsSchema;
    constructor Create;
  public
    function GetName: string;
    function SetName(ANameTools: string): IMCPServerTools;
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

function TMCPServerToolsSchema.SetProperties(AKey: string; AValue: TProType): IMCPServerToolsSchema;
begin
  FProperties.Add(AKey, AValue);
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

function TMCPServerToolsSchemaTypes.GetPropType: TProType;
begin
  Result := FPropType;
end;

class function TMCPServerToolsSchemaTypes.New: IMCPServerToolsSchemaTypes;
begin
  Result := TMCPServerToolsSchemaTypes.Create;
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
  end;
end;

end.
