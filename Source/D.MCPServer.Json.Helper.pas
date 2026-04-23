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

{ File     : D.MCPServer.Json.Helper }
{ Developer: Daniel Fernandes Rodrigures }
{ Email    : danielfernandesroddrigues@gmail.com }
{ this unit is a part of the Open Source. }
{ licensed under a MIT - see LICENSE.md}

{ ******************************************************* }

unit D.MCPServer.Json.Helper;

interface

uses
  System.SysUtils, System.JSON, Variants;

type
  TTypeReturnGetParam = (trString, trInt, trFloat, trBool, trDateTime);

  TJSONObjectHelper = class helper for TJSONObject
    function AddPair(const Str: string; const Val: Boolean): TJSONObject; overload;
    function AddPair(const Str: string; const Val: Integer): TJSONObject; overload;
    function GetParam(ANameParam: string; ATypeReturn: TTypeReturnGetParam = trString): Variant;
  end;

implementation

function TJSONObjectHelper.AddPair(const Str: string; const Val: Boolean): TJSONObject;
begin
  Result := Self.AddPair(TJSONPair.Create(Str, TJSONBool.Create(Val)));
end;

function TJSONObjectHelper.AddPair(const Str: string; const Val: Integer): TJSONObject;
begin
  Result := Self.AddPair(TJSONPair.Create(Str, TJSONNumber.Create(Val)));
end;

function TJSONObjectHelper.GetParam(ANameParam: string; ATypeReturn: TTypeReturnGetParam): Variant;
var
  lParams: TJSONObject;
  lValue: string;
  lFormatSettings: TFormatSettings;
begin
  lValue := '';
  if not Self.TryGetValue(ANameParam, lValue) then
  begin
    lParams := Self.GetValue('params') as TJSONObject;
    if lParams <> nil then
    begin
      try
        lParams.TryGetValue(ANameParam, lValue);
      finally
        lParams.Free;
      end;
    end;
  end;

  case ATypeReturn of
     trString: Result := lValue;
     trInt:  Result := StrToIntDef(lValue, 0);
     trFloat:  Result := StrToFloatDef(lValue, 0);
     trBool:  Result := StrToBoolDef(lValue, False);
     trDateTime:
       begin
         if lValue.Contains('-') then
         begin
           lFormatSettings := TFormatSettings.Create;
           lFormatSettings.ShortDateFormat := 'yyyy-mm-dd';
           lFormatSettings.DateSeparator := '-';

           Result := StrToDate(lValue, lFormatSettings);
         end
         else
           Result := StrToDateDef(lValue, 0);
       end
   else
     Result := lValue;
  end;
end;

end.
