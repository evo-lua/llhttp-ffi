local IncrementalHttpParser = import("../../IncrementalHttpParser.lua")

local scenario = Scenario:Construct("Parsing HTTP responses")

scenario:GIVEN("I create a new parser instance")
scenario:WHEN("The parser executes a valid response")
scenario:THEN("It should generate a HttpResponse object")

function scenario:OnSetup()
	self.parser = IncrementalHttpParser:Construct()
end

function scenario:OnRun()
	-- self.bindings = _G.llhttp.bindings -- In the runtime, this would be preloaded and can be required

	local request = "HTTP/1.1 200 OK\r\nHeader1: Value1\r\nHeader2:\t Value2\r\nContent-Length: 0\r\n\r\n";
	self.parser:Execute(request)
end

function scenario:OnEvaluate()
	-- for _, functionName in ipairs(exportedApiSurface) do
	-- 	assertEquals(type(self.bindings[functionName]), "cdata", "Should bind function " .. functionName)
	-- end

	-- assertFalse(self.parser:)
end

return scenario