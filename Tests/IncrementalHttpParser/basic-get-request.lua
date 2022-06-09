local IncrementalHttpParser = import("../../IncrementalHttpParser.lua")

local scenario = Scenario:Construct("Parsing HTTP requests")

scenario:GIVEN("I create a new parser instance")
scenario:WHEN("The parser executes a valid GET request")
scenario:THEN("It should to generate a HttpRequest object")

function scenario:OnSetup()
	self.parser = IncrementalHttpParser:Construct()
end

function scenario:OnRun()
	-- self.bindings = _G.llhttp.bindings -- In the runtime, this would be preloaded and can be required

	local request = "GET / HTTP/1.1\r\n\r\n";
	self.parser:Execute(request)

	self.parser:Reset()

	local websocketsUpgradeRequest = "GET /chat HTTP/1.1\r\nHost: example.com:8000\r\nUpgrade: websocket\r\nConnection: Upgrade\r\nSec-WebSocket-Key: dGhlIHNhbXBsZSBub25jZQ==\r\nSec-WebSocket-Version: 13\r\n\r\n"
	self.parser:Execute(websocketsUpgradeRequest)

	-- local NUM_ITERATIONS = 100000
	-- local ssl = require("openssl")
	-- local uv = require("uv")
	-- local math_random = math.random
	-- local math_huge = math.huge
	-- math.randomseed(uv.hrtime())
	-- function GenerateRandomString()
	-- 	local length = math_random(1, 100)
	-- 	local randomString= ssl.random(length)
	-- 	return randomString
	-- end
	-- -- for i=1, NUM_ITERATIONS, 1 do
	-- while true do
	-- 	local randomString = GenerateRandomString()
	-- 	self.parser:Reset()
	-- 	self.parser:Execute(randomString)
	-- end
end

function scenario:OnEvaluate()
	-- for _, functionName in ipairs(exportedApiSurface) do
	-- 	assertEquals(type(self.bindings[functionName]), "cdata", "Should bind function " .. functionName)
	-- end

	-- assertFalse(self.parser:)
end

return scenario