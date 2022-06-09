local llhttp = _G.llhttp

collectgarbage()
local preCreateMemoryUsage = collectgarbage("count")
-- printf("Memory used before creating a parser instance: %s kB", preCreateMemoryUsage)

local parser = llhttp.create()

local memoryUsage = collectgarbage("count")
-- printf("Memory used after creating a parser instance: %s kB", memoryUsage)

assert(type(parser.state) == "cdata", "Should set up the local state for the parser instance")
assert(type(parser.settings) == "cdata", "Should set up a settings table for the parser instance")

parser = nil
collectgarbage()

local postDestroyMemoryUsage = collectgarbage("count")
-- printf("Memory used after destroying a parser instance: %s kB", postDestroyMemoryUsage)

local memoryUsageDifference = postDestroyMemoryUsage - preCreateMemoryUsage
-- This is somewhat sketchy, but as long as the test case itself isn't messing things up it should still work?
assert(memoryUsageDifference <= 0, " Should not leak memory when parser instances are destroyed (post-GC)")

printf("%s\t%s", transform.green("OK"), transform.yellow("parser.create"))