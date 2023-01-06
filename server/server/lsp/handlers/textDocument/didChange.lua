local parse = require("moonscript.parse")
return function(self, params)
  if params.contentChanges then
    self.content = params.contentChanges[1].text
  else
    self.content = params.textDocument.text
  end
  local uri = params.textDocument.uri
  io.stderr:write(self.content)
  local tree, err_line, err_pos, err_end = parse.string_raw(self.content)
  local diagnostics = { }
  if not (tree) then
    io.stderr:write(err_line, err_pos)
    diagnostics = {
      {
        range = {
          start = {
            line = err_line - 1,
            character = err_pos - 1
          },
          ["end"] = {
            line = err_line - 1,
            character = err_end - 1
          }
        },
        severity = 1,
        source = "test",
        message = "Error: " .. tostring(err)
      }
    }
  end
  return {
    method = "textDocument/publishDiagnostics",
    params = {
      uri = uri,
      diagnostics = diagnostics
    }
  }
end
