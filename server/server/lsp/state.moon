import decode, encode from require "util.jsonrpc"

class ServerState
	new: =>
		@initialized = false
		@pendingNotifications = {}
		@symbols = {}
		@symbolDeclarationMap = {}
		@symbolNodeMap = {}
		@symbolPositionMap = {}

	notify: (notification) =>
		table.insert @pendingNotifications, notification

	symbolIterator: =>
		queue = {}
		for symbol in *@symbols
			table.insert queue, symbol

		->
			return nil if #queue == 0
			item = table.remove queue, 1
			if item.children
				for child in *item.children
					table.insert queue, child

			return item
