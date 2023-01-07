local null
null = require("util.json").null
return function(self, params)
  self.uri = params.textDocument.uri
  local line, character = params.position.line, params.position.character
  local includeDeclaration = params.context.includeDeclaration
  local _list_0 = self.symbols
  for _index_0 = 1, #_list_0 do
    local symbol = _list_0[_index_0]
    if symbol.selectionRange.start.line == line and symbol.selectionRange["end"].line == line and symbol.selectionRange.start.character - 1 <= character and symbol.selectionRange["end"].character >= character then
      local declarationNode = self.symbolDeclarationMap[symbol]
      if not (declarationNode) then
        return null
      end
      if declarationNode.uses then
        local references
        do
          local _accum_0 = { }
          local _len_0 = 1
          local _list_1 = declarationNode.uses
          for _index_1 = 1, #_list_1 do
            local use = _list_1[_index_1]
            _accum_0[_len_0] = {
              uri = self.uri,
              range = {
                start = {
                  line = use.selectionRange.start.line,
                  character = use.selectionRange.start.character - 1
                },
                ["end"] = {
                  line = use.selectionRange["end"].line,
                  character = use.selectionRange["end"].character
                }
              }
            }
            _len_0 = _len_0 + 1
          end
          references = _accum_0
        end
        if includeDeclaration then
          table.insert(references, {
            uri = self.uri,
            range = {
              start = {
                line = symbol.selectionRange.start.line,
                character = symbol.selectionRange.start.character - 1
              },
              ["end"] = {
                line = symbol.selectionRange["end"].line,
                character = symbol.selectionRange["end"].character
              }
            }
          })
        end
        return references
      else
        return null
      end
    end
  end
  return null
end
