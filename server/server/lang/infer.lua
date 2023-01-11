local inferName
do
  local inferByAssign
  inferByAssign = function(node)
    local assignNode = node.parent
    if not assignNode then
      return nil
    end
    assignNode = assignNode.parent
    if not assignNode or assignNode.name ~= "assign" then
      return nil
    end
    local refNode = assignNode[2][node.index]
    if not refNode or refNode.name ~= "ref" then
      return nil
    end
    return refNode[2]
  end
  local inferByTableKey
  inferByTableKey = function(node)
    local keyNode = node.parent
    if not keyNode then
      return nil
    end
    keyNode = keyNode[1]
    if not keyNode or keyNode.name ~= "key_literal" then
      return nil
    end
    return keyNode[2]
  end
  inferName = function(node)
    return inferByAssign(node) or inferByTableKey(node)
  end
end
return {
  inferName = inferName
}
