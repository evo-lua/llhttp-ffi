local HttpMessage = {}

function HttpMessage:Construct()
	-- shared: headers, body
	-- statusLine: method, requestedURL/queryString, versionString (request) or versionString, statusCode, statusText
	-- __tostring
end

-- IsRequest

-- IsResponse

return HttpMessage