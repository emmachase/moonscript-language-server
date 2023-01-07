return function(self, params)
  self.uri = params.textDocument.uri
  return self.symbols
end
