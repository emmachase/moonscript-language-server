local print
print = require("util.out").print
local json = require("util.json")
local readProtoHeader
readProtoHeader = function(reader)
  local header = { }
  print("hellllooo")
  while true do
    local line = reader("*l")
    print("Saw line " .. tostring(line))
    if line == "" then
      print("Got empty line, breaking")
      break
    end
    local k, v = line:match('^([^:]+)%s*%:%s*(.+)$')
    header[k] = v
  end
  return header
end
return {
  encode = function(packet)
    packet.jsonrpc = "2.0"
    local content = json.encode(packet)
    local result = "Content-Length: " .. tostring(#content) .. "\r\n\r\n" .. tostring(content)
    return result
  end,
  decode = function(reader)
    local header = readProtoHeader(reader)
    print(header["Content-Length"])
    local content = reader(tonumber(header["Content-Length"]))
    return json.decode(content)
  end
}
