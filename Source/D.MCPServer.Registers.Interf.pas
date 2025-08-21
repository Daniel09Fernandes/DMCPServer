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

{ File     : D.MCPServer.Registers.Interf.pas }
{ Developer: Daniel Fernandes Rodrigures }
{ Email    : danielfernandesroddrigues@gmail.com }
{ this unit is a part of the Open Source. }
{ licensed under a MIT - see LICENSE.md}

{ ******************************************************* }
unit D.MCPServer.Registers.Interf;

interface

uses
  System.Generics.Collections,
  D.MCPServer.Registers.Tools.Interf;

type
  IMCPServerInfos = interface;

  IMCPServerInfoTools = interface
  ['{F305A146-B0D1-4C5C-A630-8DF6C56DB3B5}']

    function Tools: TList<IMCPServerTools>; overload;
    function Tools(AListTools: IMCPServerTools): IMCPServerInfos; overload;
  end;

  IMCPServerInfos = interface(IMCPServerInfoTools)
    ['{54F355AD-1FD0-45C0-91DC-41FABC34BB7D}']

    function SetServerName(AServerName: string): IMCPServerInfos;
    function GetServerName: string;
    function SetVersion(AServerName: string): IMCPServerInfos;
    function GetVersion: string;
  end;

implementation

end.
