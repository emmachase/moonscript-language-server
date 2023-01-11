return function(self, params)
  self.initialized = true
  return {
    capabilities = {
      textDocumentSync = 1,
      documentSymbolProvider = true,
      definitionProvider = true,
      referencesProvider = true
    },
    serverInfo = {
      name = "Moonscript Language Server"
    }
  }
end
