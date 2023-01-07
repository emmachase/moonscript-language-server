return function(self)
  local tree, err_line, err_pos, err_end = parse.string_raw(self.content)
  local diagnostics = { }
  print(tree)
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
  return self:notify({
    method = "textDocument/publishDiagnostics",
    params = {
      uri = self.uri,
      diagnostics = diagnostics
    }
  })
end
