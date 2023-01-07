parse = require "moonscript.parse"
validate = require "lang.validate"

(params) =>
	if params.contentChanges
		@content = params.contentChanges[1].text
	else
		@content = params.textDocument.text

	@uri = params.textDocument.uri

	io.stderr\write @content

	validate @

	-- Publish diagnostics
