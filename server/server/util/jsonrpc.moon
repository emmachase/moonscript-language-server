import print from require "util.out"

json = require "util.json"

readProtoHeader = (reader) ->
    header = {}
    print "hellllooo"
    while true
        line = reader("*l")
        print "Saw line #{line}"
        if line == ""
            print "Got empty line, breaking"
            break
        k, v = line\match '^([^:]+)%s*%:%s*(.+)$'
        header[k] = v
    header

{
    encode: (packet) ->
        packet.jsonrpc = "2.0"
        content = json.encode packet
        result = "Content-Length: #{#content}\r\n\r\n#{content}"

        -- I really don't understand why this is necessary, but it is.
        -- padding = 0
        -- while #result % 2 == 1
        --     padding += 1
        --     result = "Content-Length: #{#content+padding}\r\n\r\n#{(" ")\rep(padding)}#{content}"

        result
        

    decode: (reader) ->
        header = readProtoHeader reader
        print header["Content-Length"]
        content = reader tonumber header["Content-Length"]
        json.decode content
}
