import null from require "util.json"

(params) =>
	@uri = params.textDocument.uri

	line, character = params.position.line, params.position.character

	-- Find the symbol at the given position
	for symbol in *@symbols
		if symbol.selectionRange.start.line == line               and
		   symbol.selectionRange.end.line == line                 and
		   symbol.selectionRange.start.character - 1 <= character and 
		   symbol.selectionRange.end.character >= character
		    declarationNode = @symbolDeclarationMap[symbol]
			return null unless declarationNode

			declarationSymbol = @symbolPositionMap[declarationNode[-1]]
			if declarationSymbol
				return {
					uri: @uri,
					range: {
						start: {
							line: declarationSymbol.selectionRange.start.line,
							character: declarationSymbol.selectionRange.start.character - 1,
						},
						end: {
							line: declarationSymbol.selectionRange.end.line,
							character: declarationSymbol.selectionRange.end.character,
						},
					},
				}
			else
				return null
	
	null
