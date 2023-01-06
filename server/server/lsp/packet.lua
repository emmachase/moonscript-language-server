local handlers = require("lsp.handlers")
local ErrorCodes = {
  ParseError = -32700,
  InvalidRequest = -32600,
  MethodNotFound = -32601,
  InvalidParams = -32602,
  InternalError = -32603,
  serverErrorStart = -32099,
  serverErrorEnd = -32000,
  ServerNotInitialized = -32002,
  UnknownErrorCode = -32001,
  RequestFailed = -32803,
  ServerCancelled = -32802,
  ContentModified = -32801,
  RequestCancelled = -32800
}
return function(self, request)
  local id, method, params
  id, method, params = request.id, request.method, request.params
  method = handlers[method]
  if not method then
    if id then
      return {
        id = id,
        error = {
          code = ErrorCodes.MethodNotFound,
          message = "Method '" .. tostring(method) .. "' Not Found"
        }
      }
    else
      return 
    end
  end
  local result = method(self, params)
  if id then
    return {
      id = id,
      result = result
    }
  else
    return result
  end
end
