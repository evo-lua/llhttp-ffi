local ffi = require("ffi")

local isWindows = (ffi.os == "Windows")

local WINDOWS_SHARED_LIBRARY_EXTENSION = "dll"
local UNIX_SHARED_LIBRARY_EXTENSION = "so"
local expectedFileExtension = isWindows and WINDOWS_SHARED_LIBRARY_EXTENSION or UNIX_SHARED_LIBRARY_EXTENSION

local llhttp = {
	cdefs = [[
		// We only need those because we have to access the userdata pointer in a structured way
		typedef char* String;

		typedef struct ListElement{
			struct ListElement* previous;
			String value;
			size_t numCharacters;
		} ListElement;

		typedef struct {
			size_t length;
			ListElement* tail;
			size_t totalSpanSizeInBytes;
		} LinkedList;

		// This struct will be assigned to the void userdata pointer instead of its actual type, so that we can access it here
		typedef struct {
			LinkedList* tokens;
			LinkedList* headerKeyValueTokens;
			String url;
			String status;
			String* headerKeysAndValues;
			size_t numHeaderPairs;
		} RequestDetails;

		struct llhttp__internal_s {
			int32_t _index;
			void* _span_pos0;
			void* _span_cb0;
			int32_t error;
			const char* reason;
			const char* error_pos;
			RequestDetails* data;
			// Actually: void* data;
			void* _current;
			uint64_t content_length;
			uint8_t type;
			uint8_t method;
			uint8_t http_major;
			uint8_t http_minor;
			uint8_t header_state;
			uint8_t lenient_flags;
			uint8_t upgrade;
			uint8_t finish;
			uint16_t flags;
			uint16_t status_code;
			void* settings;
		};
		typedef struct llhttp__internal_s llhttp__internal_t;
		typedef llhttp__internal_t llhttp_t;
		typedef int (*llhttp_data_cb)(llhttp_t* parser_state, const char *at, size_t length);
		// Note: Parameters at & length are useless for llhttp_cb, do not use them in non-llhttp_data_cb callbacks
		typedef int (*llhttp_cb)(llhttp_t*parser_state, const char *at, size_t length);

		struct llhttp_settings_s {
			/* Possible return values 0, -1, `HPE_PAUSED` */
			llhttp_cb			on_message_begin;

			/* Possible return values 0, -1, HPE_USER */
			llhttp_data_cb on_url;
			llhttp_data_cb on_status;
			llhttp_data_cb on_header_field;
			llhttp_data_cb on_header_value;

			/* Possible return values:
			* 0	- Proceed normally
			* 1	- Assume that request/response has no body, and proceed to parsing the
			*			next message
			* 2	- Assume absence of body (as above) and make `llhttp_execute()` return
			*			`HPE_PAUSED_UPGRADE`
			* -1 - Error
			* `HPE_PAUSED`
			*/
			llhttp_cb			on_headers_complete;

			/* Possible return values 0, -1, HPE_USER */
			llhttp_data_cb on_body;

			/* Possible return values 0, -1, `HPE_PAUSED` */
			llhttp_cb			on_message_complete;

			/* When on_chunk_header is called, the current chunk length is stored
			* in parser->content_length.
			* Possible return values 0, -1, `HPE_PAUSED`
			*/
			llhttp_cb			on_chunk_header;
			llhttp_cb			on_chunk_complete;

			/* Information-only callbacks, return value is ignored */
			llhttp_cb			on_url_complete;
			llhttp_cb			on_status_complete;
			llhttp_cb			on_header_field_complete;
			llhttp_cb			on_header_value_complete;
		};
		typedef struct llhttp_settings_s llhttp_settings_t;

		enum llhttp_type {
			HTTP_BOTH = 0,
			HTTP_REQUEST = 1,
			HTTP_RESPONSE = 2
		};
		typedef enum llhttp_type llhttp_type_t;
		void llhttp_init(llhttp_t* parser, llhttp_type_t type, const llhttp_settings_t* settings);

		enum llhttp_errno {
			HPE_OK = 0,
			HPE_INTERNAL = 1,
			HPE_STRICT = 2,
			HPE_LF_EXPECTED = 3,
			HPE_UNEXPECTED_CONTENT_LENGTH = 4,
			HPE_CLOSED_CONNECTION = 5,
			HPE_INVALID_METHOD = 6,
			HPE_INVALID_URL = 7,
			HPE_INVALID_CONSTANT = 8,
			HPE_INVALID_VERSION = 9,
			HPE_INVALID_HEADER_TOKEN = 10,
			HPE_INVALID_CONTENT_LENGTH = 11,
			HPE_INVALID_CHUNK_SIZE = 12,
			HPE_INVALID_STATUS = 13,
			HPE_INVALID_EOF_STATE = 14,
			HPE_INVALID_TRANSFER_ENCODING = 15,
			HPE_CB_MESSAGE_BEGIN = 16,
			HPE_CB_HEADERS_COMPLETE = 17,
			HPE_CB_MESSAGE_COMPLETE = 18,
			HPE_CB_CHUNK_HEADER = 19,
			HPE_CB_CHUNK_COMPLETE = 20,
			HPE_PAUSED = 21,
			HPE_PAUSED_UPGRADE = 22,
			HPE_PAUSED_H2_UPGRADE = 23,
			HPE_USER = 24
		};
		typedef enum llhttp_errno llhttp_errno_t;
		llhttp_errno_t llhttp_execute(llhttp_t* parser, const char* data, size_t len);

		int Bindings_OnMessageBegin(llhttp_t*, const char*, size_t);
		int Bindings_OnURL(llhttp_t*, const char*, size_t);
		int Bindings_OnStatus(llhttp_t*, const char*, size_t);
		int Bindings_OnHeaderField(llhttp_t*, const char*, size_t);
		int Bindings_OnHeaderValue(llhttp_t*, const char*, size_t);
		int Bindings_OnHeadersComplete(llhttp_t*, const char*, size_t);
		int Bindings_OnBody(llhttp_t*, const char*, size_t);
		int Bindings_OnMessageComplete(llhttp_t*, const char*, size_t);
		int Bindings_OnChunkHeader(llhttp_t*, const char*, size_t);
		int Bindings_OnChunkComplete(llhttp_t*, const char*, size_t);
		int Bindings_OnUrlComplete(llhttp_t*, const char*, size_t);
		int Bindings_OnStatusComplete(llhttp_t*, const char*, size_t);
		int Bindings_OnHeaderFieldComplete(llhttp_t*, const char*, size_t);
		int Bindings_OnHeaderValueComplete(llhttp_t*, const char*, size_t);

		void Bindings_InitializeUserData(llhttp_t* parserState);
	]],
	PARSER_TYPES = {
		HTTP_BOTH = 0,
		HTTP_REQUEST = 1,
		HTTP_RESPONSE = 2
	},
	ERROR_TYPES = {
		HPE_OK = 0,
		HPE_INTERNAL = 1,
		HPE_STRICT = 2,
		HPE_LF_EXPECTED = 3,
		HPE_UNEXPECTED_CONTENT_LENGTH = 4,
		HPE_CLOSED_CONNECTION = 5,
		HPE_INVALID_METHOD = 6,
		HPE_INVALID_URL = 7,
		HPE_INVALID_CONSTANT = 8,
		HPE_INVALID_VERSION = 9,
		HPE_INVALID_HEADER_TOKEN = 10,
		HPE_INVALID_CONTENT_LENGTH = 11,
		HPE_INVALID_CHUNK_SIZE = 12,
		HPE_INVALID_STATUS = 13,
		HPE_INVALID_EOF_STATE = 14,
		HPE_INVALID_TRANSFER_ENCODING = 15,
		HPE_CB_MESSAGE_BEGIN = 16,
		HPE_CB_HEADERS_COMPLETE = 17,
		HPE_CB_MESSAGE_COMPLETE = 18,
		HPE_CB_CHUNK_HEADER = 19,
		HPE_CB_CHUNK_COMPLETE = 20,
		HPE_PAUSED = 21,
		HPE_PAUSED_UPGRADE = 22,
		HPE_PAUSED_H2_UPGRADE = 23,
		HPE_USER = 24
	},
	HTTP_METHODS = {
		HTTP_DELETE = 0,
		HTTP_GET = 1,
		HTTP_HEAD = 2,
		HTTP_POST = 3,
		HTTP_PUT = 4,
		HTTP_CONNECT = 5,
		HTTP_OPTIONS = 6,
		HTTP_TRACE = 7,
		HTTP_COPY = 8,
		HTTP_LOCK = 9,
		HTTP_MKCOL = 10,
		HTTP_MOVE = 11,
		HTTP_PROPFIND = 12,
		HTTP_PROPPATCH = 13,
		HTTP_SEARCH = 14,
		HTTP_UNLOCK = 15,
		HTTP_BIND = 16,
		HTTP_REBIND = 17,
		HTTP_UNBIND = 18,
		HTTP_ACL = 19,
		HTTP_REPORT = 20,
		HTTP_MKACTIVITY = 21,
		HTTP_CHECKOUT = 22,
		HTTP_MERGE = 23,
		HTTP_MSEARCH = 24,
		HTTP_NOTIFY = 25,
		HTTP_SUBSCRIBE = 26,
		HTTP_UNSUBSCRIBE = 27,
		HTTP_PATCH = 28,
		HTTP_PURGE = 29,
		HTTP_MKCALENDAR = 30,
		HTTP_LINK = 31,
		HTTP_UNLINK = 32,
		HTTP_SOURCE = 33,
		HTTP_PRI = 34,
		HTTP_DESCRIBE = 35,
		HTTP_ANNOUNCE = 36,
		HTTP_SETUP = 37,
		HTTP_PLAY = 38,
		HTTP_PAUSE = 39,
		HTTP_TEARDOWN = 40,
		HTTP_GET_PARAMETER = 41,
		HTTP_SET_PARAMETER = 42,
		HTTP_REDIRECT = 43,
		HTTP_RECORD = 44,
		HTTP_FLUSH = 45
	}
}

ffi.cdef(llhttp.cdefs)

local parserLibrary = ffi.load("llhttp" .. "." .. expectedFileExtension)
local callbackHandlers = ffi.load("llhttp_ffi" .. "." .. expectedFileExtension)

function llhttp.create()

	local parser = ffi.new("llhttp_t")
	local settings = ffi.new("llhttp_settings_t")

	settings.on_message_begin = callbackHandlers.Bindings_OnMessageBegin
	settings.on_url = callbackHandlers.Bindings_OnURL
	settings.on_status = callbackHandlers.Bindings_OnStatus
	settings.on_header_field = callbackHandlers.Bindings_OnHeaderField
	settings.on_header_value = callbackHandlers.Bindings_OnHeaderValue
	settings.on_headers_complete = callbackHandlers.Bindings_OnHeadersComplete
	settings.on_body = callbackHandlers.Bindings_OnBody
	settings.on_message_complete = callbackHandlers.Bindings_OnMessageComplete
	settings.on_chunk_header = callbackHandlers.Bindings_OnChunkHeader
	settings.on_chunk_complete = callbackHandlers.Bindings_OnChunkComplete
	settings.on_url_complete = callbackHandlers.Bindings_OnUrlComplete
	settings.on_status_complete = callbackHandlers.Bindings_OnStatusComplete
	settings.on_header_field_complete = callbackHandlers.Bindings_OnHeaderFieldComplete
	settings.on_header_value_complete = callbackHandlers.Bindings_OnHeaderValueComplete

	parserLibrary.llhttp_init(parser, llhttp.PARSER_TYPES.HTTP_BOTH, settings)

	callbackHandlers.Bindings_InitializeUserData(parser)

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
	self.parsedURL = ffi.string(self.state.data.url)
	self.version = tonumber(self.state.http_major) + tonumber(self.state.http_minor) / 10

	-- TBD: Make it optional? May use a lot of memory if large (or even just many small) messages are received and cached
	self.lastProcessedToken = stringToParse
	local expectedNumberOfHeaderPairs = tonumber(self.state.data.numHeaderPairs)
	printf("Expecting %d header pairs", expectedNumberOfHeaderPairs)

	self.headers = {}

	if expectedNumberOfHeaderPairs > 0 then
		printf("Processing %d header pairs", expectedNumberOfHeaderPairs)

		for headerID = 1, expectedNumberOfHeaderPairs do
			local storedValue = ffi.string(self.state.data.headerKeysAndValues[headerID - 1])
			printf("Processing header %d: %s", headerID, storedValue)
			table.insert(self.headers, storedValue) -- TBD Store as k, v or hash map? Multiples may occur... see nodeJS issues (referenced)
		end
	end
end

function llhttp:finish()
end

function llhttp:finish() end

return llhttp