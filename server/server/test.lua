package.path = "?.lua;server/?.lua;server/?/init.lua"
local ServerState = require("lsp.state")
local validate = require("lang.validate")
local state = ServerState()
state.content = "package.path = '?.lua;server/?.lua;server/?/init.lua'\n\nServerState = require 'lsp.state'\nvalidate = require 'lang.validate'\n\nstate = ServerState!\n\n\n\nvalidate state"
return validate(state)
