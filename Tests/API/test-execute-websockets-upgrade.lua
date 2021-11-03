local llhttp = _G.llhttp

local parser = llhttp.create()

local websocketsUpgradeRequest = "GET /chat HTTP/1.1\r\nHost: example.com:8000\r\nUpgrade: websocket\r\nConnection: Upgrade\r\nSec-WebSocket-Key: dGhlIHNhbXBsZSBub25jZQ==\r\nSec-WebSocket-Version: 13"
parser:execute(websocketsUpgradeRequest)

-- dump(parser)
-- parser:dump()

assert(parser.ok, "The parser should not enter an error state after executing a valid request")
assert(parser.method == llhttp.HTTP_METHODS.HTTP_GET, "Should parse the HTTP method correctly after executing a valid request")
assert(parser.parsedURL == "/chat", "Should parse the URL correctly after executing a valid request")
assert(parser.version == 1.1, "Should parse the HTTP version correctly after executing a valid request")
assert(parser.headers.host == "example.com:8000", "Should parse the Host header correctly after executing a valid request")
assert(parser.headers.connection == "upgrade", "Should parse the Connection header correctly after executing a valid request")
assert(parser.headers.upgrade == "websocket", "Should parse the Upgrade header correctly after executing a valid request")
assert(parser.headers["sec-websocket-key"] == "dGhlIHNhbXBsZSBub25jZQ==", "Should parse the Sec-WebSocket-Key header correctly after executing a valid request")
assert(parser.headers["sec-websocket-version"] == "13", "Should parse the Sec-WebSocket-Version header correctly after executing a valid request")

printf("%s\t%s", transform.green("OK"), transform.yellow("parser.execute-websockets-upgrade"))