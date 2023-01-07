local null
null = require("util.json").null
return function(self, params)
  self.uri = params.textDocument.uri
  local line, character = params.position.line, params.position.character
  local _list_0 = self.symbols
  for _index_0 = 1, #_list_0 do
    local symbol = _list_0[_index_0]
    if symbol.selectionRange.start.line == line and symbol.selectionRange["end"].line == line and symbol.selectionRange.start.character <= character and symbol.selectionRange["end"].character >= character then
      local declarationNode = self.symbolDeclarationMap[symbol]
      if not (declarationNode) then
        return null
      end
      local declarationSymbol = self.symbolPositionMap[declarationNode[-1]]
      if declarationSymbol then
        return {
          uri = self.uri,
          range = {
            start = {
              line = declarationSymbol.selectionRange.start.line,
              character = declarationSymbol.selectionRange.start.character - 1
            },
            ["end"] = {
              line = declarationSymbol.selectionRange["end"].line,
              character = declarationSymbol.selectionRange["end"].character
            }
          }
        }
      else
        return null
      end
    end
  end
  return null
end
