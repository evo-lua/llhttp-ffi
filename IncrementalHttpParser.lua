
local ffi_string = ffi.string

local parserLibrary = ffi.load("llhttp" .. "." .. expectedFileExtension)

function llhttp.create() -- IncrementalHttpParser:Construct()

	local parser = ffi.new("llhttp_t")
	local settings = ffi.new("llhttp_settings_t")

	settings.on_message_begin = function() print("on_message_begin") return 0 end
	settings.on_url = function(parser, urlPointer, urlLength)
		local parsedURL = ffi_string(urlPointer, urlLength)
		print("OnURL", parsedURL) -- self:OnURL(parsedURL)

		return llhttp.ERROR_TYPES.HPE_OK
	end
	settings.on_status = function() print("on_status") return 0 end
	settings.on_header_field = function() print("on_header_field") return 0 end
	settings.on_header_value = function() print("on_header_value") return 0 end
	settings.on_headers_complete = function() print("on_headers_complete") return 0 end
	settings.on_body = function() print("on_body") return 0 end
	settings.on_message_complete = function() print("on_message_complete") return 0 end
	settings.on_chunk_header = function() print("on_chunk_header") return 0 end
	settings.on_chunk_complete = function() print("on_chunk_complete") return 0 end
	settings.on_url_complete = function() print("on_url_complete") return 0 end
	settings.on_status_complete = function() print("on_status_complete") return 0 end
	settings.on_header_field_complete = function() print("on_header_field_complete") return 0 end
	settings.on_header_value_complete = function() print("on_header_value_complete") return 0 end
	parserLibrary.llhttp_init(parser, llhttp.PARSER_TYPES.HTTP_BOTH, settings)
	local instance = {}

	instance.state = parser
	instance.settings = settings
	setmetatable(instance, { __index = llhttp})

	return instance
end

function llhttp:reset() end
function llhttp:execute(stringToParse)
	-- printf("Executing string %s", stringToParse)
	parserLibrary.llhttp_execute(self.state, stringToParse, #stringToParse)

	self.contentLength = tonumber(self.state.content_length)
	self.errorCode = tonumber(self.state.error)
	self.ok = (self.errorCode == llhttp.ERROR_TYPES.HPE_OK)
	self.method = tonumber(self.state.method)
	-- self.parsedURL = ffi.string(self.state.data.url)
	self.version = tonumber(self.state.http_major) + tonumber(self.state.http_minor) / 10

	-- TBD: Make it optional? May use a lot of memory if large (or even just many small) messages are received and cached
	-- self.lastProcessedToken = stringToParse
	-- local expectedNumberOfHeaderPairs = tonumber(self.state.data.numHeaderPairs)
	-- printf("Expecting %d header pairs", expectedNumberOfHeaderPairs)

	self.headers = {}

	-- if expectedNumberOfHeaderPairs > 0 then
	-- 	printf("Processing %d header pairs", expectedNumberOfHeaderPairs)

	-- 	for headerID = 1, expectedNumberOfHeaderPairs, 2 do

	-- 		-- We can rely on this since llhttp parses in order field, value and fires the callbacks correctly (hopefully)
	-- 		local headerKey = ffi.string(self.state.data.headerKeysAndValues[headerID - 1])
	-- 		local headerValue = ffi.string(self.state.data.headerKeysAndValues[headerID])
	-- 		-- TODO Test cases for capitalization
	-- 		-- Header keys are case-insensitive according to the HTTP spec
	-- 		printf("Processing header k/v pair %d => %s: %s", headerID, headerKey, headerValue)
	-- 		headerKey = string.lower(headerKey)
	-- 		-- headerValue = string.lower(headerValue) -- But values are not
	-- 		-- TODO Test cases for multiple identical fields
	-- 			if self.headers[headerKey] ~= nil then
	-- 				-- 		-- Already exists, add as comma-separated value (TBD: Should we verify this is allowed?)
	-- 				self.headers[headerKey] = self.headers[headerKey]  .. ", " .. headerValue
	-- 			else
	-- 				-- 		-- First value (common case)
	-- 				self.headers[headerKey] = headerValue
	-- 			end
	-- 				dump(self.headers)

	-- 	end
	-- end
end

function llhttp:finish()
end

function llhttp:finish() end