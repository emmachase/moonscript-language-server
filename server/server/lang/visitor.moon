import ntype from require "moonscript.types"

visitNode = (node, visitors) ->
	if node.name
		nodeType = ntype node
		switch type visitors[nodeType]
			when "string"
				return visitors[visitors[nodeType]] node
			when "function"
				return visitors[nodeType] node
			else
				if visitors.default
					return visitors.default node

visit = (tree, visitors) ->
	if type(visitors) == "function" then visitors = { default: visitors }
	return unless tree

	popFun = visitNode tree, visitors

	for node in *tree
		if type(node) == "table"
			visit node, visitors -- recurse

	if type(popFun) == "function" then popFun!

{ :visit }
