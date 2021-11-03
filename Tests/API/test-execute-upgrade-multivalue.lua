local llhttp = _G.llhttp

local parser = llhttp.create()

local websocketsUpgradeRequest = "GET /index.html HTTP/1.1\r\nHost: www.example.com\r\nConnection: upgrade\r\nUpgrade: example/1, foo/2";
parser:execute(websocketsUpgradeRequest)

-- dump(parser)
-- parser:dump()

assert(parser.ok, "The parser should not enter an error state after executing a valid request")
assert(parser.method == llhttp.HTTP_METHODS.HTTP_GET, "Should parse the HTTP method correctly after executing a valid request")
assert(parser.parsedURL == "/index.html", "Should parse the URL correctly after executing a valid request")
assert(parser.version == 1.1, "Should parse the HTTP version correctly after executing a valid request")
assert(parser.headers.host == "www.example.com", "Should parse the Host header correctly after executing a valid request")
assert(parser.headers.connection == "upgrade", "Should parse the Connection header correctly after executing a valid request")
assert(parser.headers.upgrade == "example/1, foo/2", "Should parse the Upgrade header correctly after executing a valid request")

printf("%s\t%s", transform.green("OK"), transform.yellow("parser.execute-upgrade-multivalue"))