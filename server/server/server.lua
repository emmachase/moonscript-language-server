package.path = "?.lua;server/?.lua;server/?/init.lua"
local decode, encode
do
  local _obj_0 = require("util.jsonrpc")
  decode, encode = _obj_0.decode, _obj_0.encode
end
local print
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
  do
    local result = PacketHandler(serverState, packet)
    if result then
      print("Sending response")
      print(encode(result))
      puts(encode(result))
    end
  end
end
