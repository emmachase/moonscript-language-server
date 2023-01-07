local parse = require("moonscript.parse")
local pprint = require("util.pprint")
local print
print = require("util.out").print
local zip
zip = require("util.fun").zip
local SymbolKind
SymbolKind = require("lsp.types.symbol").SymbolKind
local pos_to_line_column
pos_to_line_column = require("moonscript.util").pos_to_line_column
local ntype
ntype = require("moonscript.types").ntype
local visit
visit = require("lang.visitor").visit
local findSymbols
findSymbols = function(self, tree)
  local symbols = { }
  local scopeStack = {
    { }
  }
  local pushStack
  pushStack = function()
    do
      local _tbl_0 = { }
      for k, v in pairs(scopeStack[#scopeStack]) do
        _tbl_0[k] = v
      end
      scopeStack[#scopeStack + 1] = _tbl_0
    end
    return function()
      scopeStack[#scopeStack] = nil
    end
  end
  visit(tree, {
    import = "declare_with_shadows",
    declare_with_shadows = function(node)
      local line, character = pos_to_line_column(self.content, node[-1])
      local range = {
        start = {
          line = line,
          character = character
        },
        ["end"] = {
          line = line,
          character = character
        }
      }
      local declaration = node
      local symbol = {
        name = name,
        kind = SymbolKind.Variable,
        range = range,
        selectionRange = range
      }
      self.symbolPositionMap[node[-1]] = symbol
      local _list_0 = node[2]
      for _index_0 = 1, #_list_0 do
        local name = _list_0[_index_0]
        scopeStack[#scopeStack][name] = node
      end
    end,
    declare_glob = function(node)
      local line, character = pos_to_line_column(self.content, node[-1])
      local range = {
        start = {
          line = line,
          character = character
        },
        ["end"] = {
          line = line,
          character = character
        }
      }
      scopeStack[#scopeStack].glob = node
      self.symbolPositionMap[node[-1]] = {
        name = "*",
        kind = SymbolKind.Variable,
        range = range,
        selectionRange = range
      }
    end,
    assign = function(node)
      local _list_0 = zip(node[2], node[3])
      for _index_0 = 1, #_list_0 do
        local pair = _list_0[_index_0]
        local k, v
        k, v = pair[1], pair[2]
        print(k, v)
        if type(k) == "table" and k[1] == "ref" then
          scopeStack[#scopeStack][k[2]] = scopeStack[#scopeStack][k[2]] or (scopeStack[#scopeStack].glob or k)
        end
      end
    end,
    ref = function(node)
      local line, character = pos_to_line_column(self.content, node[-1])
      local range = {
        start = {
          line = line,
          character = character
        },
        ["end"] = {
          line = line,
          character = character + #node[2] - 1
        }
      }
      local declaration = scopeStack[#scopeStack][node[2]]
      local symbol = {
        name = node[2],
        kind = SymbolKind.Variable,
        range = range,
        selectionRange = range
      }
      self.symbolDeclarationMap[symbol] = declaration
      self.symbolPositionMap[node[-1]] = symbol
      symbols[#symbols + 1] = symbol
    end,
    fndef = function(node)
      local popFun = pushStack()
      local _list_0 = node[2]
      for _index_0 = 1, #_list_0 do
        local _continue_0 = false
        repeat
          local arg = _list_0[_index_0]
          if not (type(arg[1]) == "string") then
            _continue_0 = true
            break
          end
          local line, character = pos_to_line_column(self.content, arg[-1])
          local range = {
            start = {
              line = line,
              character = character
            },
            ["end"] = {
              line = line,
              character = character + #arg[1] - 1
            }
          }
          local declaration = arg
          scopeStack[#scopeStack][arg[1]] = arg
          local symbol = {
            name = arg[1],
            kind = SymbolKind.Variable,
            range = range,
            selectionRange = range
          }
          self.symbolDeclarationMap[symbol] = declaration
          self.symbolPositionMap[arg[-1]] = symbol
          symbols[#symbols + 1] = symbol
          _continue_0 = true
        until true
        if not _continue_0 then
          break
        end
      end
      return popFun
    end,
    ["if"] = pushStack,
    ["else"] = pushStack,
    ["elseif"] = pushStack,
    unless = pushStack,
    ["while"] = pushStack,
    ["for"] = pushStack,
    foreach = pushStack,
    ["do"] = pushStack,
    with = pushStack,
    switch = pushStack
  })
  return symbols
end
return function(self)
  local err_line, err_pos, err_end
  self.tree, err_line, err_pos, err_end = parse.string_raw(self.content)
  local diagnostics = { }
  print("hi")
  self.symbols = findSymbols(self, self.tree)
  print("aw")
  print(self.symbolDeclarationMap)
  if not (self.tree) then
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
