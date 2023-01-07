return function(self, params)
  self.initialized = true
  return {
    capabilities = {
      textDocumentSync = 1,
      documentSymbolProvider = true,
      definitionProvider = true
    },
    serverInfo = {
      name = "Moonscript Language Server"
    }
  }
end
