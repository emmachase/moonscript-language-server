package.path = "?.lua;server/?.lua;server/?/init.lua"

ServerState = require "lsp.state"
validate = require "lang.validate"

state = ServerState!

state.content = "package.path = '?.lua;server/?.lua;server/?/init.lua'\n\nServerState = require 'lsp.state'\nvalidate = require 'lang.validate'\n\nstate = ServerState!\n\n\n\nvalidate state"

validate state
