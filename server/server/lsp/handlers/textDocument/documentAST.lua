local parse = require("moonscript.parse")
local line_column_to_pos, pos_to_line_column
do
  local _obj_0 = require("moonscript.util")
  line_column_to_pos, pos_to_line_column = _obj_0.line_column_to_pos, _obj_0.pos_to_line_column
end
local validate = require("lang.validate")
local pprint = require("util.pprint")
local visit
visit = require("lang.visitor").visit
return function(self, params)
  self.content = params.textDocument.text
  self.uri = params.textDocument.uri
  validate(self)
  local line, character = params.selection.start.line, params.selection.start.character
  local pos = line_column_to_pos(self.content, line, character)
  local distance, closestNode = math.huge, self.tree
  visit(self.tree, function(node)
    if node[-1] and math.abs(node[-1] - pos) < distance then
      distance = math.abs(node[-1] - pos)
      closestNode = node
    end
  end)
  closestNode.MARKER = "<<HERE>>"
  local treeString = pprint.pformat(self.tree)
  local markerPosition = treeString:find("<<HERE>>")
  closestNode.MARKER = nil
  line, character = pos_to_line_column(treeString, markerPosition)
  return {
    tree = treeString,
    range = {
      start = {
        line = line,
        character = character
      },
      ["end"] = {
        line = line,
        character = character
      }
    }
  }
end
