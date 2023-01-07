return {
  initialize = require("lsp.handlers.initialize"),
  ["textDocument/didChange"] = require("lsp.handlers.textDocument.didChange"),
  ["textDocument/didOpen"] = require("lsp.handlers.textDocument.didChange"),
  ["textDocument/documentSymbol"] = require("lsp.handlers.textDocument.documentSymbol"),
  ["textDocument/definition"] = require("lsp.handlers.textDocument.definition")
}
