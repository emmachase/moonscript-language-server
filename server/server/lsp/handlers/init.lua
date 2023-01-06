return {
  initialize = require("lsp.handlers.initialize"),
  ["textDocument/didChange"] = require("lsp.handlers.textDocument.didChange"),
  ["textDocument/didOpen"] = require("lsp.handlers.textDocument.didChange")
}
