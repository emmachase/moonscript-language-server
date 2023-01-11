import null from require "util.json"

(params) =>
	@uri = params.textDocument.uri

	line, character = params.position.line, params.position.character
	includeDeclaration = params.context.includeDeclaration

	-- Find the symbol at the given position
	for symbol in @symbolIterator!
		if symbol.selectionRange.start.line == line               and
		   symbol.selectionRange.end.line == line                 and
		   symbol.selectionRange.start.character - 1 <= character and 
		   symbol.selectionRange.end.character >= character
		    declarationNode = @symbolDeclarationMap[symbol]
			return null unless declarationNode

			if declarationNode.uses
				references = for use in *declarationNode.uses
					{
						uri: @uri,
						range: {
							start: {
								line: use.selectionRange.start.line,
								character: use.selectionRange.start.character - 1,
							},
							end: {
								line: use.selectionRange.end.line,
								character: use.selectionRange.end.character,
							},
						},
					}

				if includeDeclaration
					table.insert references, {
						uri: @uri,
						range: {
							start: {
								line: symbol.selectionRange.start.line,
								character: symbol.selectionRange.start.character - 1,
							},
							end: {
								line: symbol.selectionRange.end.line,
								character: symbol.selectionRange.end.character,
							},
						},
					}

				return references
			else
				return null
	
	null
