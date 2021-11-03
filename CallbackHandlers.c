// TODO: Rename to llhttpcb or sth?

// We need the typedefs from lhttp since otherwise the implemented callback handlers won't be compatible
#include "llhttp.h"

#include "Settings.c"

// Shorthands
typedef char* String;

// Note on return values: These have the potential to make the parser enter an error state (set error code to the return value, if nonzero)
// For "data" callbacks (llhttp_data_cb): See comments in llhttp.h's llhttp_settings_s struct
// For "informational" callbacks: The return value is ignored (so we simply return zero)

// Note on passed arguments: llhttp will give you access to the parser state, including userdata ('data' field) that you can use to store custom structs
// llhttp_data_cb: second argument points to the start of the buffer that contains the relevant String; third argument tells you how many chars to read
// llhttp_cb: the provided arguments (beyond the parser state) are most likely garbage/invalid and shouldn't be used! IME the third is 100% useless.

int Bindings_OnMessageBegin(llhttp_t* parserState, const String remainingBufferContent, size_t numRelevantBytes) {
	DEBUG("[Bindings_OnMessageBegin]\n");
	return 0;
}

int Bindings_OnURL(llhttp_t* parserState, const String remainingBufferContent, size_t numRelevantBytes) {
	DEBUG("[Bindings_OnURL]\n");
	return 0;
}

int Bindings_OnStatus(llhttp_t* parserState, const String remainingBufferContent, size_t numRelevantBytes) {
	DEBUG("[Bindings_OnStatus]\n");
	return 0;
}

// Triggered by llhttp whenever a header field is being parsed.
// Note: Can occur multiple times if the field (as received via TCP packets) is split across multiple buffers!
int Bindings_OnHeaderField(llhttp_t* parserState, const String remainingBufferContent, size_t numRelevantBytes) {
	DEBUG("[Bindings_OnHeaderField]\n");
	return 0;
}

int Bindings_OnHeaderValue(llhttp_t* parserState, const String remainingBufferContent, size_t numRelevantBytes) {
	DEBUG("[Bindings_OnHeaderValue]\n");
	return 0;
}

int Bindings_OnHeadersComplete(llhttp_t* parserState, const String remainingBufferContent, size_t numRelevantBytes) {
	DEBUG("[Bindings_OnHeadersComplete]\n");
	return 0;
}

int Bindings_OnBody(llhttp_t* parserState, const String remainingBufferContent, size_t numRelevantBytes) {
	DEBUG("[Bindings_OnBody]\n");
	return 0;
}

int Bindings_OnMessageComplete(llhttp_t* parserState, const String remainingBufferContent, size_t numRelevantBytes) {
	DEBUG("[Bindings_OnMessageComplete]\n");
	return 0;
}

int Bindings_OnChunkHeader(llhttp_t* parserState, const String remainingBufferContent, size_t numRelevantBytes) {
	DEBUG("[Bindings_OnChunkHeader]\n");
	return 0;
}

int Bindings_OnChunkComplete(llhttp_t* parserState, const String remainingBufferContent, size_t numRelevantBytes) {
	DEBUG("[Bindings_OnChunkComplete]\n");
	return 0;
}

int Bindings_OnUrlComplete(llhttp_t* parserState, const String remainingBufferContent, size_t numRelevantBytes) {
	DEBUG("[Bindings_OnUrlComplete]\n");
	return 0;
}

int Bindings_OnStatusComplete(llhttp_t* parserState, const String remainingBufferContent, size_t numRelevantBytes) {
	DEBUG("[Bindings_OnStatusComplete]\n");
	return 0;
}

int Bindings_OnHeaderFieldComplete(llhttp_t* parserState, const String remainingBufferContent, size_t numRelevantBytes) {
	DEBUG("[Bindings_OnHeaderFieldComplete]\n");
	return 0;
}

int Bindings_OnHeaderValueComplete(llhttp_t* parserState, const String remainingBufferContent, size_t numRelevantBytes) {
	DEBUG("[Bindings_OnHeaderValueComplete]\n");
	return 0;
}
