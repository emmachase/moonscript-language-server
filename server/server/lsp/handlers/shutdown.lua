local null
null = require("util.json").null
return function(self, params)
  self.shutdown = true
  return null
end
