handlers = require "lsp.handlers"

ErrorCodes = {
	-- Defined by JSON RPC
	ParseError: -32700,
	InvalidRequest: -32600,
	MethodNotFound: -32601,
	InvalidParams: -32602,
	InternalError: -32603,

	serverErrorStart: -32099,
	serverErrorEnd: -32000,

	ServerNotInitialized: -32002,
	UnknownErrorCode: -32001,

	-- Defined by the protocol.
	RequestFailed: -32803,
	ServerCancelled: -32802,
	ContentModified: -32801,
	RequestCancelled: -32800,
}

---@param request table The request to be sent to the server
(request) =>
	{ :id, :method, :params } = request

	-- Find the method to call
	method = handlers[method]
	if not method
		if id then return { :id, error: { code: ErrorCodes.MethodNotFound, message: "Method '#{method}' Not Found" } }
		else return -- Drop the notification

	result = method @, params -- TODO: pcall

	-- Send the result back to the server
	if id then { :id, :result } else result
