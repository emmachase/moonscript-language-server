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
  return {
    defaultBehavior = true
  }
end
