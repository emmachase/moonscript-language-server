inferName = do
	inferByAssign = (node) ->
		-- node.parent?.parent?(assign)[2][i](ref)[2]
		-- Try to infer name of the node from what it's assigned to
		assignNode = node.parent
		return nil if not assignNode
		assignNode = assignNode.parent
		return nil if not assignNode or assignNode.name != "assign"
		
		refNode = assignNode[2][node.index]
		return nil if not refNode or refNode.name != "ref"
		return refNode[2]

	inferByTableKey = (node) ->
		-- node.parent?[1](key_literal)[2]
		-- Try to infer name of the node from what it's used as a key in a table
		keyNode = node.parent
		return nil if not keyNode
		keyNode = keyNode[1]
		return nil if not keyNode or keyNode.name != "key_literal"
		return keyNode[2]

	(node) -> inferByAssign(node) or inferByTableKey(node)

{ :inferName }
