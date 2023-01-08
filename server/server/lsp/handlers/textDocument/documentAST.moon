parse = require "moonscript.parse"
import line_column_to_pos, pos_to_line_column from require "moonscript.util"
validate = require "lang.validate"
pprint = require "util.pprint"
import visit from require "lang.visitor"

(params) => 
	@content = params.textDocument.text
	@uri = params.textDocument.uri

	validate @

	line, character = params.selection.start.line, params.selection.start.character

	-- line, character -> position
	pos = line_column_to_pos @content, line, character

	-- Find the closest node to the cursor
	distance, closestNode = math.huge, @tree
	visit @tree, (node) ->
		if node[-1] and math.abs(node[-1] - pos) < distance
			distance = math.abs(node[-1] - pos)
			closestNode = node

	closestNode.MARKER = "<<HERE>>"
	treeString = pprint.pformat @tree
	markerPosition = treeString\find "<<HERE>>"
	closestNode.MARKER = nil

	line, character = pos_to_line_column treeString, markerPosition

	-- Dump the pretty-printed syntax tree as a result
	{
		tree: treeString
		range: {
			start: {
				line: line
				character: character
			}
			end: {
				line: line
				character: character
			}
		}
	}
