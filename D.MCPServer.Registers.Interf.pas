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
