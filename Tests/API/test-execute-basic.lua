local llhttp = _G.llhttp

local parser = llhttp.create()

local superBasicRequest = "GET / HTTP/1.1\r\n\r\n";
parser:execute(superBasicRequest)

dump(parser)
parser:dump()

assert(parser.ok, "The parser should not enter an error state after executing a valid request")
assert(parser.method == llhttp.HTTP_METHODS.HTTP_GET, "Should parse the HTTP method correctly after executing a valid request")
assert(parser.parsedURL == "/", "Should parse the URL correctly after executing a valid request")
assert(parser.version == 1.1, "Should parse the HTTP version correctly after executing a valid request")

printf("%s\t%s", transform.green("OK"), transform.yellow("parser.execute"))