{ 
	initialize: require "lsp.handlers.initialize",
	shutdown: require "lsp.handlers.shutdown",
	exit: require "lsp.handlers.exit",

	["textDocument/didChange"]: require "lsp.handlers.textDocument.didChange",
	["textDocument/didOpen"]:   require "lsp.handlers.textDocument.didChange", -- TODO

	["textDocument/documentSymbol"]: require "lsp.handlers.textDocument.documentSymbol",
	["textDocument/definition"]: require "lsp.handlers.textDocument.definition",
	["textDocument/references"]: require "lsp.handlers.textDocument.references",

	["textDocument/prepareRename"]: require "lsp.handlers.textDocument.prepareRename",
	["textDocument/rename"]: require "lsp.handlers.textDocument.rename",

	["textDocument/documentAST"]: require "lsp.handlers.textDocument.documentAST",
}
