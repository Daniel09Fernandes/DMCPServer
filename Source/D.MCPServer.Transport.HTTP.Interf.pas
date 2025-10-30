unit D.MCPServer.Transport.HTTP.Interf;

interface

uses
  System.Classes, System.JSON;

type
  IDMCPTransport = interface
    ['{0169701D-85E5-4201-8C24-34F9E34711BF}']
    procedure Start;
    procedure Stop;
    procedure SendResponse(const Response: TJSONObject);
    function IsActive: Boolean;
  end;

  IDMCPTransportFactory = interface
    ['{B79A1C40-594A-48BE-A40A-62A901776D17}']
    function CreateTransport(const Config: TJSONObject): IDMCPTransport;
  end;

implementation

end.
