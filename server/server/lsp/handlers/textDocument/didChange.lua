local parse = require("moonscript.parse")
local validate = require("lang.validate")
return function(self, params)
  if params.contentChanges then
    self.content = params.contentChanges[1].text
  else
    self.content = params.textDocument.text
  end
  self.uri = params.textDocument.uri
  io.stderr:write(self.content)
  return validate(self)
end
