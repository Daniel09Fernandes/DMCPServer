unit D.MCPServer.Registers.Tools.Interf;

interface

Uses System.Generics.Collections;

type
  TProType = (ptString, ptInteger, ptDouble, ptJson, ptObject, ptArray, ptText, ptBoolean);

  IMCPServerTools = interface;
  IMCPServerToolsSchema = interface;

  IMCPServerToolsSchemaTypes = interface
    ['{1CF46AD8-9B6C-4360-BD0F-6CFB5D12C228}']

    function GetPropType: TProType;
    function SetPropType(APropType: TProType): IMCPServerToolsSchemaTypes;
  end;

  IMCPServerToolsSchema = interface
    ['{6134FEEE-6D25-474A-8B6A-C4A6FC85AF52}']

    function GetType: TProType;
    function SetType(AType: TProType): IMCPServerToolsSchema;
    function GetProperties: TDictionary<string, TProType>;
    function SetProperties(AKey: string; AValue: TProType): IMCPServerToolsSchema;
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
    function InputSchema: IMCPServerToolsSchema;
  end;

implementation

end.
