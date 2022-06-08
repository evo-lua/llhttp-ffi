local llhttp = _G.llhttp

local expectedFields = {
	-- Format: name = type
	PARSER_TYPES = "table",
	ERROR_TYPES = "table",
	HTTP_METHODS = "table",
}

for fieldName, expectedType in pairs(expectedFields) do
	assert(type(llhttp[fieldName]) == expectedType, string.format("Should export %s constant: %s", expectedType, fieldName))
end

local exportedApiSurface = {
	"create", -- llhttp_init
	"reset", -- llhttp_reset
	"execute", -- llhttp_execute
	"finish", -- llhttp_finish
	-- wasm api not available yet, but should be exposed...
	-- llhttp_get_type
	-- llhttp_get_http_major
	-- llhttp_get_http_minor
	-- llhttp_get_method
	-- llhttp_get_status_code
	-- llhttp_get_upgrade
	-- TBD: Is this useful?
	-- llhttp_settings_init
	-- llhttp_message_needs_eof
	-- llhttp_should_keep_alive
	-- llhttp_pause
	-- llhttp_resume
	-- llhttp_resume_after_upgrade
	-- llhttp_get_error_reason
	-- llhttp_set_error_reason
	-- llhttp_get_error_pos
	-- llhttp_errno_name
	-- llhttp_method_name
	-- Probably not wise to use these at all
	-- llhttp_set_lenient_headers
	-- llhttp_set_lenient_chunked_length
	-- llhttp_set_lenient_keep_alive
}

for index, functionName in pairs(exportedApiSurface) do
	assert(type(llhttp[functionName]) == "function", "Should export function: " .. functionName)
end

printf("%s\t%s", transform.green("OK"), transform.yellow("api-surface"))