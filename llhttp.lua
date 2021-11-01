local ffi = require("ffi")

local isWindows = (ffi.os == "Windows")

local WINDOWS_SHARED_LIBRARY_EXTENSION = "dll"
local UNIX_SHARED_LIBRARY_EXTENSION = "so"

local llhttp = {
	expectedFileExtension = isWindows and WINDOWS_SHARED_LIBRARY_EXTENSION or UNIX_SHARED_LIBRARY_EXTENSION,
	cdefs = [[
		// TODO
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
		{
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
}

function llhttp.create() end
function llhttp.reset() end
function llhttp.execute(stringToParse) end
function llhttp.finish() end

return llhttp