package.path = "?.lua;server/?.lua;server/?/init.lua"
print = function() end
local decode, encode
do
  local _obj_0 = require("util.jsonrpc")
  decode, encode = _obj_0.decode, _obj_0.encode
end
print = require("util.out").print
local ServerState = require("lsp.state")
local PacketHandler = require("lsp.packet")
print("Starting Language Server")
local serverState = ServerState()
local reader
do
  local _base_0 = io.stdin
  local _fn_0 = _base_0.read
  reader = function(...)
    return _fn_0(_base_0, ...)
  end
end
local setmode, puts
do
  local _obj_0 = require("lib.filemode")
  setmode, puts = _obj_0.setmode, _obj_0.puts
end
setmode(io.stdout, "b")
io.stdout:setvbuf('no')
io.stdin:setvbuf('no')
while true do
  print("Waiting for packet")
  local packet = decode(reader)
  print(packet)
  local s, e = pcall(function()
    do
      local result = PacketHandler(serverState, packet)
      if result then
        print("Sending response")
        print(result)
        return puts(encode(result))
      end
    end
  end)
  if not s then
    print("Error handling packet")
    print(e)
    serverState:notify({
      method = "window/logMessage",
      params = {
        type = 1,
        message = tostring(e)
      }
    })
  end
  while #serverState.pendingNotifications > 0 do
    puts(encode(table.remove(serverState.pendingNotifications, 1)))
  end
end
