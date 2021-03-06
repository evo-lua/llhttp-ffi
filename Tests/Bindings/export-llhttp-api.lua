local scenario = Scenario:Construct("Exporting the llhttp API")

scenario:WHEN("I load llhttp as a shared library using the FFI")
scenario:THEN("All exported functions should be available")

-- Taken from llhttp.def
local exportedApiSurface = {
	"llhttp_init",
	"llhttp_reset",
	"llhttp_settings_init",
	"llhttp_execute",
	"llhttp_finish",
	"llhttp_message_needs_eof",
	"llhttp_should_keep_alive",
	"llhttp_pause",
	"llhttp_resume",
	"llhttp_resume_after_upgrade",
	"llhttp_get_errno",
	"llhttp_get_error_reason",
	"llhttp_set_error_reason",
	"llhttp_get_error_pos",
	"llhttp_errno_name",
	"llhttp_method_name",
	"llhttp_set_lenient_headers",
	"llhttp_set_lenient_chunked_length",
	"llhttp_set_lenient_keep_alive",
}

function scenario:OnRun()
	self.bindings = _G.llhttp.bindings -- In the runtime, this would be preloaded and can be required
end

function scenario:OnEvaluate()
	for _, functionName in ipairs(exportedApiSurface) do
		assertEquals(type(self.bindings[functionName]), "cdata", "Should bind function " .. functionName)
	end
end

return scenario