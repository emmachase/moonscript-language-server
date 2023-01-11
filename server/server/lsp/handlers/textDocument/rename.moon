import null from require "util.json"


getReferences = require "lsp.handlers.textDocument.references"

(params) =>
	references = getReferences(@, {
		textDocument: params.textDocument,
		position: params.position,
		context: {
			includeDeclaration: true
		}
	})

	return null if references == null

	changes = {}
	for reference in *references
		uri = reference.uri
		changes[uri] or= {}
		table.insert changes[uri], {
			range: reference.range,
			newText: params.newName
		}

	{ :changes }
