import ntype from require "moonscript.types"

visit = (tree, visitors) ->
	if type(visitors) == "function" then visitors = { default: visitors }

	return unless tree

	for node in *tree
		if type(node) == "table"
			local popFun

			if node.name
				nodeType = ntype node
				switch type visitors[nodeType]
					when "string"
						popFun = visitors[visitors[nodeType]] node
					when "function"
						popFun = visitors[nodeType] node
					else
						if visitors.default
							popFun = visitors.default node

		
			visit node, visitors

			if type(popFun) == "function" then popFun!

{ :visit }
