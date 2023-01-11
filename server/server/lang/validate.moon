parse = require "moonscript.parse"
pprint = require "util.pprint"
import print from require "util.out"
import zip from require "util.fun"

import SymbolKind from require "lsp.types.symbol"
import pos_to_line_column from require "moonscript.util"
import ntype from require "moonscript.types"

import visit from require "lang.visitor"
import inferName from require "lang.infer"

findSymbols = (tree) =>
	symbols = {}
	scopeStack = {{}}

	pushStack = ->
		-- Clone the top scope
		scopeStack[#scopeStack + 1] = { k, v for k, v in pairs scopeStack[#scopeStack] }
		-> scopeStack[#scopeStack] = nil -- Pop

	pushClosureStack = (node, symbolFn) ->
		popFun = pushStack!
		oldSymbols = symbols

		line, character = pos_to_line_column @content, node[-1]
		line2, character2 = pos_to_line_column @content, node[-2]
		range = {
			start: { :line, :character },
			["end"]: { line: line2, character: character2 - 1 },
		}
		fnSymbol = symbolFn node, range
		symbols[#symbols + 1] = fnSymbol

		-- Any new symbols are children of the function symbol
		symbols = fnSymbol.children

		-> -- Unwind
			popFun!
			symbols = oldSymbols

	visit tree, {
		import: "declare_with_shadows"
		declare_with_shadows: (node) ->
			-- TODO: Add ref positions for each name individually
			line, character = pos_to_line_column @content, node[-1]
			range = {
				start: { :line, :character },
				["end"]: { :line, :character },
			}

			declaration = node
			symbol = { 
				:name, 
				kind: SymbolKind.Variable, 
				:range, selectionRange: range
			}

			@symbolPositionMap[node[-1]] = symbol
			
			for name in *node[2]
				scopeStack[#scopeStack][name] = node -- functions always make new local scope
				
				-- @symbolDeclarationMap[symbol] = declaration
				-- symbols[#symbols + 1] = symbol

		declare_glob: (node) ->
			line, character = pos_to_line_column @content, node[-1]
			range = {
				start: { :line, :character },
				["end"]: { :line, :character },
			}

			scopeStack[#scopeStack].glob = node
			@symbolPositionMap[node[-1]] = { 
				name: "*", 
				kind: SymbolKind.Variable, 
				:range, selectionRange: range
			}

		assign: (node) ->
			for pair in *zip node[2], node[3]
				{ k, v } = pair
				print k, v
				if type(k) == "table"
					visit k, {
						ref: (node) -> scopeStack[#scopeStack][node[2]] or= scopeStack[#scopeStack].glob or node
					}
					
		ref: (node) ->
			if @content\sub(node[-1], node[-1]) == " "
				node[-1] += 1 -- TODO: Fix this hack

			line, character = pos_to_line_column @content, node[-1]

			range = {
				start: { :line, :character },
				["end"]: { :line, character: character + #node[2] - 1 },
			}

			declaration = scopeStack[#scopeStack][node[2]]
			symbol = { 
				name: node[2], 
				kind: SymbolKind.Variable, 
				:range, selectionRange: range
			}

			if type(declaration) == "table"
				declaration.uses or= {}
				declaration.uses[#declaration.uses + 1] = symbol

			@symbolNodeMap[symbol] = node
			@symbolDeclarationMap[symbol] = declaration
			@symbolPositionMap[node[-1]] = symbol
			symbols[#symbols + 1] = symbol

		class: (node) ->
			pushClosureStack node, (node, range) ->
				{
					name: node[2] or inferName(node) or "class",
					kind: SymbolKind.Class, 
					:range, selectionRange: range,
					children: {}
				}

		fndef: (node) ->
			popFun = pushClosureStack node, (node, range) ->
				{
					name: inferName(node) or "function",
					kind: node[4] == "fat" and SymbolKind.Method or SymbolKind.Function, 
					:range, selectionRange: range,
					children: {}
				}

			-- Args are symbols
			for arg in *node[2]
				continue unless type(arg[1]) == "string" -- TODO: Add support for @

				line, character = pos_to_line_column @content, arg[-1]
				range = {
					start: { :line, :character },
					["end"]: { :line, character: character + #arg[1] - 1 },
				}

				declaration = arg -- scopeStack[#scopeStack][arg[1]]
				scopeStack[#scopeStack][arg[1]] = arg -- functions always make new local scope
				symbol = { 
					name: arg[1], 
					kind: SymbolKind.Variable, 
					:range, selectionRange: range
				}

				@symbolNodeMap[symbol] = arg
				@symbolDeclarationMap[symbol] = declaration
				@symbolPositionMap[arg[-1]] = symbol
				symbols[#symbols + 1] = symbol

			popFun -- Unwind
		
		if: pushStack
		else: pushStack
		elseif: pushStack
		unless: pushStack
		while: pushStack
		for: pushStack
		foreach: pushStack
		do: pushStack
		with: pushStack
		switch: pushStack

		-- TODO: Needs backtracking
		-- dot: (node) ->
		-- 	for name in node.names
		-- 		symbols[name] = node.line
	}

	-- pprint scopeStack
	symbols

=>
	@tree, err_line, err_pos, err_end = parse.string_raw @content
	diagnostics = {}

	-- pprint @tree

	print "hi"
	@symbols = findSymbols @, @tree
	print "aw"
	print @symbolDeclarationMap

	unless @tree
		io.stderr\write err_line, err_pos
		diagnostics = {
			{
				range: {
					start: { line: err_line - 1, character: err_pos - 1 },
					["end"]: { line: err_line - 1, character: err_end - 1 },
				},
				severity: 1,
				source: "test",
				message: "Error: #{err}",
			}
		}

	@notify {
		method: "textDocument/publishDiagnostics",
		params: {
			uri: @uri,
			:diagnostics
		}
	}
