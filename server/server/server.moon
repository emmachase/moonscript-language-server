-- Language Server using standard LSP protocol
-- Uses stdio for communication

-- Rewrite package path to include the 'server' directory
package.path = "?.lua;server/?.lua;server/?/init.lua"

export print = ->

import decode, encode from require "util.jsonrpc"
import print from require "util.out"

ServerState = require "lsp.state"
PacketHandler = require "lsp.packet"

print "Starting Language Server"
serverState = ServerState!

reader = io.stdin\read

import setmode, puts from require "lib.filemode"
-- setmode(io.stdin,  "b")
setmode(io.stdout,  "b")
io.stdout\setvbuf 'no'
io.stdin\setvbuf  'no'

-- x = 1

while true
    print "Waiting for packet"
    packet = decode reader
    print packet

    s, e = pcall ->
        if result = PacketHandler serverState, packet
            print "Sending response"
            print result
            --io.write (encode(result))
            puts encode result
            -- io.flush!

    if not s
        print "Error handling packet"
        print e
        serverState\notify {
            method: "window/logMessage",
            params: {
                type: 1,
                message: tostring e
            }
        }

    while #serverState.pendingNotifications > 0
        puts encode table.remove serverState.pendingNotifications, 1

    -- x = x + 1
    -- if x >= 4
    --     -- sleep for 1 second
    --     -- os.execute "sleep 1"
    --     -- test a diagnostic
    --     print(encode({
    --         method: "textDocument/publishDiagnostics",
    --         params: {
    --             uri: "file:///c%3A/Users/me/Downloads/test%20TEST%20test.moon",
    --             diagnostics: {
    --                 {
    --                     range: {
    --                         start: { line: 0, character: 0 },
    --                         ["end"]: { line: 0, character: 4 },
    --                     },
    --                     severity: 1,
    --                     source: "test",
    --                     message: "test",
    --                 }
    --             }
    --         }
    --     }))
    --     puts(encode({
    --         method: "textDocument/publishDiagnostics",
    --         params: {
    --             uri: "file:///c%3A/Users/me/Downloads/test%20TEST%20test.moon",
    --             diagnostics: {
    --                 {
    --                     range: {
    --                         start: { line: 0, character: 0 },
    --                         ["end"]: { line: 0, character: 4 },
    --                     },
    --                     severity: 1,
    --                     source: "test",
    --                     message: "test",
    --                 }
    --             }
    --         }
    --     }))
    --     -- io.flush!
