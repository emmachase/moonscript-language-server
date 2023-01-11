local null
null = require("util.json").null
local getReferences = require("lsp.handlers.textDocument.references")
return function(self, params)
  local references = getReferences(self, {
    textDocument = params.textDocument,
    position = params.position,
    context = {
      includeDeclaration = true
    }
  })
  if references == null then
    return null
  end
  local changes = { }
  for _index_0 = 1, #references do
    local reference = references[_index_0]
    local uri = reference.uri
    changes[uri] = changes[uri] or { }
    table.insert(changes[uri], {
      range = reference.range,
      newText = params.newName
    })
  end
  return {
    changes = changes
  }
end
