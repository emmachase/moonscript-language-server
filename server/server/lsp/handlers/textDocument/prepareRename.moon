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
	{ defaultBehavior: true }
