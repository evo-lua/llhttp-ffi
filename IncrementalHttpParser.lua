local llhttp = import("./llhttp.lua")
local bindings = llhttp.bindings

local ffi = require("ffi")

local ffi_new = ffi.new
local ffi_string = ffi.string
local format = format
local setmetatable = setmetatable
local tonumber = tonumber

local IncrementalHttpParser = {}

function IncrementalHttpParser:Construct()

	local parserState = ffi_new("llhttp_t")
	local settings = ffi_new("llhttp_settings_t")

	-- Possible return values 0, -1, HPE_PAUSED
	settings.on_message_begin = function(parserState)
		self:OnMessageBegin()
		return llhttp.ERROR_TYPES.HPE_OK
	end

	-- Possible return values 0, -1, HPE_USER
	settings.on_url = function(parserState, stringPointer, stringLengthInBytes)
		local parsedString = ffi_string(stringPointer, stringLengthInBytes)
		self:OnURL(parsedString)
		return llhttp.ERROR_TYPES.HPE_OK
	end

	settings.on_status = function(parserState, stringPointer, stringLengthInBytes)
		local parsedString = ffi_string(stringPointer, stringLengthInBytes)
		self:OnStatus(parsedString)
		return llhttp.ERROR_TYPES.HPE_OK
	end

	settings.on_header_field = function(parserState, stringPointer, stringLengthInBytes)
		 local parsedString = ffi_string(stringPointer, stringLengthInBytes)
		 self:OnHeaderField(parsedString)
		return llhttp.ERROR_TYPES.HPE_OK
	end

	settings.on_header_value = function(parserState, stringPointer, stringLengthInBytes)
		 local parsedString = ffi_string(stringPointer, stringLengthInBytes)
		 self:OnHeaderValue(parsedString)
		return llhttp.ERROR_TYPES.HPE_OK
	end

	-- Possible return values:
	-- 0	- Proceed normally
	-- 1	- Assume that request/response has no body, and proceed to parsing the next message
	-- 2	- Assume absence of body (as above) and make `llhttp_execute()` return HPE_PAUSED_UPGRADE
	-- -1	- Error
	-- HPE_PAUSED`
	settings.on_headers_complete = function(parserState)
		self:OnHeadersComplete()
		return llhttp.ERROR_TYPES.HPE_OK
	end

	-- Possible return values 0, -1, HPE_USER
	settings.on_body = function(parserState, stringPointer, stringLengthInBytes)
		local parsedString = ffi_string(stringPointer, stringLengthInBytes)
		self:OnBody(parsedString)
		return llhttp.ERROR_TYPES.HPE_OK
	end

	-- Possible return values 0, -1, HPE_PAUSED
	settings.on_message_complete = function(parserState)
		self:OnMessageComplete()
		return llhttp.ERROR_TYPES.HPE_OK
	end

	-- When on_chunk_header is called, the current chunk length is stored in parser->content_length.
	-- Possible return values 0, -1, `HPE_PAUSED`
	settings.on_chunk_header = function(parserState)
		self:OnChunkHeader()
		return llhttp.ERROR_TYPES.HPE_OK
	end

	settings.on_chunk_complete = function(parserState)
		self:OnChunkComplete()
		return llhttp.ERROR_TYPES.HPE_OK
	end

	-- Information-only callbacks, return value is ignored
	settings.on_url_complete = function(parserState)
		self:OnUrlComplete()
		return llhttp.ERROR_TYPES.HPE_OK
	end

	settings.on_status_complete = function(parserState)
		self:OnStatusComplete()
		return llhttp.ERROR_TYPES.HPE_OK
	end

	settings.on_header_field_complete = function(parserState)
		self:OnHeaderValueComplete()
		return llhttp.ERROR_TYPES.HPE_OK
	end

	settings.on_header_value_complete = function(parserState)
		self:OnHeaderValueComplete()
		return llhttp.ERROR_TYPES.HPE_OK
	end

	bindings.llhttp_init(parserState, llhttp.PARSER_TYPES.HTTP_BOTH, settings)

	local instance = {
		state = parserState,
		settings = settings,
	}

	setmetatable(instance, { __index = IncrementalHttpParser})

	return instance
end

function IncrementalHttpParser:Execute(chunk)
	DEBUG("Executing parser on chunk", chunk)

	local errNo = bindings.llhttp_execute(self.state, chunk, #chunk)
	local errorMessage = bindings.llhttp_errno_name(errNo)
	if tonumber(errNo) ~= llhttp.ERROR_TYPES.HPE_OK then
		self:OnError(ffi_string(errorMessage))
	end
end

function IncrementalHttpParser:OnURL(requestedURL)
	DEBUG("OnURL", requestedURL)
end

function IncrementalHttpParser:OnError(errorCode)
	DEBUG("OnError", errorCode)
	-- Would probably want to send 400 Bad Request response here?
end

function IncrementalHttpParser:OnMessageBegin()
	DEBUG("OnMessageBegin")
end

function IncrementalHttpParser:OnStatus(status)
	DEBUG("OnStatus",status)
end

function IncrementalHttpParser:OnHeaderField(fieldName)
	DEBUG("OnHeaderField", fieldName)
end

function IncrementalHttpParser:OnHeaderValue(fieldValue)
	DEBUG("OnHeaderValue", fieldValue)
end

function IncrementalHttpParser:OnHeadersComplete()
	DEBUG("OnHeadersComplete")
end

function IncrementalHttpParser:OnMessageComplete()
	DEBUG("OnMessageComplete")
end

function IncrementalHttpParser:OnBody(body)
	DEBUG("OnBody", body)
end

function IncrementalHttpParser:OnChunkHeader()
	DEBUG("OnChunkHeader")
end

function IncrementalHttpParser:OnChunkComplete()
	DEBUG("OnChunkComplete")
end

function IncrementalHttpParser:OnUrlComplete()
	DEBUG("OnUrlComplete")
end

function IncrementalHttpParser:OnStatusComplete()
	DEBUG("OnStatusComplete")
end

function IncrementalHttpParser:OnHeaderFieldComplete()
	DEBUG("OnHeaderFieldComplete")
end

function IncrementalHttpParser:OnHeaderValueComplete()
	DEBUG("OnHeaderValueComplete")
end

return IncrementalHttpParser