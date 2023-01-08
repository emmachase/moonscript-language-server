local ntype
ntype = require("moonscript.types").ntype
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
  for _index_0 = 1, #tree do
    local node = tree[_index_0]
    if type(node) == "table" then
      local popFun
      if node.name then
        local nodeType = ntype(node)
        local _exp_0 = type(visitors[nodeType])
        if "string" == _exp_0 then
          popFun = visitors[visitors[nodeType]](node)
        elseif "function" == _exp_0 then
          popFun = visitors[nodeType](node)
        else
          if visitors.default then
            popFun = visitors.default(node)
          end
        end
      end
      visit(node, visitors)
      if type(popFun) == "function" then
        popFun()
      end
    end
  end
end
return {
  visit = visit
}
