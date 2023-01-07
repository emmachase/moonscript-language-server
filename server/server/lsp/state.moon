import decode, encode from require "util.jsonrpc"

class ServerState
	new: =>
		@initialized = false
		@pendingNotifications = {}

	notify: (notification) =>
		table.insert @pendingNotifications, notification

		-- # Notify all clients that the server is ready
		-- @clients.each do |client|
		-- 	client.send "server_ready"