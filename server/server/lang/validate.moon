parse = require "moonscript.parse"

=>
	tree, err_line, err_pos, err_end = parse.string_raw @content
	diagnostics = {}

	print tree

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

	@notify {
		method: "textDocument/publishDiagnostics",
		params: {
			uri: @uri,
			:diagnostics
		}
	}
