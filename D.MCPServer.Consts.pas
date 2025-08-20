unit D.MCPServer.Consts;

interface

const
  //Log
  DMCP_LOG = 'dinos_mcp_server.log';
  DMCP_LOG_ERROR_INIT = 'Initialization Error: ';
  DMCP_LOG_CALL_INIT = 'call initialize ^';
  DMCP_LOG_CALL_TOOLS_LIST = 'call tools/list ^';
  DMCP_LOG_CALL_RESOURCE_LIST = 'call resources/list ^';
  DMCP_LOG_CALL_PROMPTS_LIST = 'prompts/list ^';
  DMCP_LOG_CALL_NOTIFY_INIT =  'call notifications/initialized ^';
  DMCP_LOG_DEBUG_STACK = 'Stack: ';
  DMCP_LOG_SERVER_INIT = 'Dinos MCPServer initialized (STDIO) - wait connections';
  DMCP_LOG_SERVER_RECIVED = 'Recived Client: ';
  DMCP_LOG_SERVER_SENDED = 'Server Sended: ';
  DMCP_LOG_SERVER_FINALIZED = 'Server Finalized';

  //Json RCP2
  DMCP_JSON_TYPE = 'type';
  DMCP_JSON_NAME = 'name';
  DMCP_JSON_INPUT_SCHEMA = 'inputSchema';
  DMCP_JSON_PROPERTIES = 'properties';
  DMCP_JSON_REQUIRED = 'required';
  DMCP_JSON_ADT_PROPS = 'additionalProperties';
  DMCP_JSON_SCHEMA = '$schema';
  DMCP_JSON_SCHEMA_VL = 'http://json-schema.org/draft-07/schema#';

  //Requests
  DMCP_REQ_PROTOCOL = 'jsonrpc';
  DMCP_REQ_ID = 'id';
  DMCP_REQ_PARAMS = 'params';
  DMCP_REQ_PROTOCOL_VERSION = 'protocolVersion';
  DMCP_REQ_METHOD = 'method';

  //Response
  DMCP_RESP_PROTOCOL_VERSION = DMCP_REQ_PROTOCOL_VERSION;
  DMCP_RESP_CAPABILITES = 'capabilities';
  DMCP_RESP_TOOLS = 'tools';
  DMCP_RESP_SERVER_INFO = 'serverInfo';
  DMCP_RESP_SERVER_NAME = 'name';
  DMCP_RESP_CONTENT = 'content';
  DMCP_RESP_TOOLS_ARGUMENTS = 'arguments';
  DMCP_RESP_SERVER_VERSION = 'version';
  DMCP_RESP_SERVER_RESULT = 'result';
  DMCP_RESP_SERVER_RESOURCE = 'resources';
  DMCP_RESP_SERVER_ERROR = 'error';
  DMCP_RESP_SERVER_ERROR_CODE = 'code';
  DMCP_RESP_SERVER_ERROR_CODE_DEFAULT = -32601;
  DMCP_RESP_SERVER_ERROR_MESSAGE = 'message';
  DMCP_RESP_SERVER_ERROR_MESSAGE_METHOD_404 = 'Method not found: ';
  DMCP_RESP_SERVER_ERROR_MESSAGE_METHOD_500 = 'Internal server error: ';

  //Methods Server
  DMCP_REQ_METHOD_INITIALIZATION = 'initialize'; //0
  DMCP_REQ_METHOD_TOOLS_LIST = 'tools/list';     //1
  DMCP_REQ_METHOD_TOOLS_CALL = 'tools/call'; //5
  DMCP_REQ_METHOD_RESOURCE_LIST = 'resources/list'; //2
  DMCP_REQ_METHOD_PROMPT_LIST = 'prompts/list';    //3
  DMCP_REQ_METHOD_NOTIFICATION_INITIALIZED = 'notifications/initialized'; //4

  DMCP_REQ_METHOD_INITIALIZATION_IDX = 0;
  DMCP_REQ_METHOD_TOOLS_LIST_IDX = 1;
  DMCP_REQ_METHOD_TOOLS_CALL_IDX = 5;
  DMCP_REQ_METHOD_RESOURCE_LIST_IDX = 2;
  DMCP_REQ_METHOD_PROMPT_LIST_IDX = 3;
  DMCP_REQ_METHOD_NOTIFICATION_INITIALIZED_IDX = 4;

  //RESOURCE LIST
  DMCP_RESOURCE_LIST_URI = 'uri';
  DMCP_RESOURCE_LIST_NAME = 'name';
  DMCP_RESOURCE_LIST_MIME_TYPE = 'mimeType';
  DMCP_RESOURCE_LIST_DESCRIPTION = 'description';

  DMCP_RESOURCE_LIST_URI_VLR = 'DinosMCPServer: Registration';
  DMCP_RESOURCE_LIST_NAME_VLR = 'DinosMCPServer';
  DMCP_RESOURCE_LIST_MIME_TYPE_VLR = 'application/json';
  DMCP_RESOURCE_LIST_DESCRIPTION_VLR = 'Portability for Delphi Methods';
implementation

end.
