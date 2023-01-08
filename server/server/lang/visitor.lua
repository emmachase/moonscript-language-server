local ntype
ntype = require("moonscript.types").ntype
local visitNode
visitNode = function(node, visitors)
  if node.name then
    local nodeType = ntype(node)
    local _exp_0 = type(visitors[nodeType])
    if "string" == _exp_0 then
      return visitors[visitors[nodeType]](node)
    elseif "function" == _exp_0 then
      return visitors[nodeType](node)
    else
      if visitors.default then
        return visitors.default(node)
      end
    end
  end
end
local visit
visit = function(tree, visitors)
  if type(visitors) == "function" then
    visitors = {
      default = visitors
    }
  end
  if not (tree) then
    return 
  end
  local popFun = visitNode(tree, visitors)
  for _index_0 = 1, #tree do
    local node = tree[_index_0]
    if type(node) == "table" then
      visit(node, visitors)
    end
  end
  if type(popFun) == "function" then
    return popFun()
  end
end
return {
  visit = visit
}
