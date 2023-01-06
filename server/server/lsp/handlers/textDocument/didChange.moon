parse = require "moonscript.parse"

(params) =>
	if params.contentChanges
		@content = params.contentChanges[1].text
	else
		@content = params.textDocument.text

	uri = params.textDocument.uri

	io.stderr\write @content
	tree, err_line, err_pos, err_end = parse.string_raw @content
	diagnostics = {}

	unless tree
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

	-- Publish diagnostics
	{
		method: "textDocument/publishDiagnostics",
		params: {
			:uri,
			:diagnostics
		}
	}
