local llhttp = _G.llhttp
local parser = llhttp.create()

dump(parser) -- todo remove

assert(type(parser.state) == "cdata", "Should set up the local state for the parser instance")
assert(type(parser.settings) == "cdata", "Should set up a settings table for the parser instance")

printf("%s\t%s", transform.green("OK"), transform.yellow("parser.create"))