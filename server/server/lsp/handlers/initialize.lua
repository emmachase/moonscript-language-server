return function(self, params)
  self.initialized = true
  return {
    capabilities = {
      textDocumentSync = 1
    },
    serverInfo = {
      name = "Moonscript Language Server"
    }
  }
end
