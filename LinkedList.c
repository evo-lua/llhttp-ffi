// Specialized linked list to help concatenate the individual strings we're passed as peacemeal or whole, depending on the circumstances.
// It's not pretty and probably horribly coded, since I'm not a C programmer. Suggestions for improvement are always welcome!

#include <stdlib.h>
#include <string.h>

#include "Settings.c"

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

typedef struct {
	LinkedList* tokens;
	LinkedList* headerKeyValueTokens;
	String url;
	String status; // todo remove, already stored in the parser state (need to update ffi cdef also... later)
	String* headerKeysAndValues;
	size_t numHeaderPairs;
} RequestDetails;

size_t referenceCount_String = 0;
size_t referenceCount_LinkedList = 0;
size_t referenceCount_ListElement = 0;
size_t referenceCount_StringBuffer = 0;
size_t referenceCount_RequestDetails = 0;

String String_Allocate(size_t numCharacters) {
	DEBUG("[String_Allocate\t%d]", numCharacters);
	String pointer = malloc(numCharacters * sizeof(char) + 1); // TBD: +1 for null terminator actually needed?
	if(pointer == NULL) {
		DEBUG("ERROR: Failed to allocate new String (%d references)", referenceCount_String);
		exit(EXIT_FAILURE);
	}
	referenceCount_String++;
	DEBUG("Allocated String (%d references)", referenceCount_String);
	return pointer;
}

LinkedList* LinkedList_Allocate() {
	DEBUG("[LinkedList_Allocate\t%d]", sizeof(LinkedList));
	LinkedList* pointer = malloc(sizeof(LinkedList));
	if(pointer == NULL) {
		DEBUG("ERROR: Failed to allocate new LinkedList (%d references)", referenceCount_LinkedList);
		exit(EXIT_FAILURE);
	}
	referenceCount_LinkedList++;
	DEBUG("Allocated LinkedList (%d references)", referenceCount_LinkedList);
	return pointer;
}

ListElement* ListElement_Allocate() {
	DEBUG("[ListElement_Allocate\t%d]", sizeof(ListElement));
	ListElement* pointer = malloc(sizeof(ListElement));
	if(pointer == NULL) {
		DEBUG("ERROR: Failed to allocate new ListElement (%d references)", referenceCount_ListElement);
		exit(EXIT_FAILURE);
	}
	referenceCount_ListElement++;
	DEBUG("Allocated ListElement (%d references)", referenceCount_ListElement);
	return pointer;
}

RequestDetails* RequestDetails_Allocate() {
	DEBUG("[RequestDetails_Allocate\t%d]", sizeof(RequestDetails));
	RequestDetails* pointer = malloc(sizeof(RequestDetails));
	if(pointer == NULL) {
		DEBUG("ERROR: Failed to allocate new RequestDetails (%d references)", referenceCount_RequestDetails);
		exit(EXIT_FAILURE);
	}
	referenceCount_RequestDetails++;
	DEBUG("Allocated RequestDetails (%d references)", referenceCount_RequestDetails);
	return pointer;
}

LinkedList* LinkedList_new() {
	DEBUG("[LinkedList_new]\n");

	LinkedList* list = LinkedList_Allocate();
	list->tail = NULL;
	list->length = 0;
	list->totalSpanSizeInBytes = 0;
	return list;
}

String LinkedList_getTail(LinkedList* list, String buffer) {
	if(list->tail == NULL) return buffer;
	strcpy(buffer, list->tail->value);
	return buffer;
}

int LinkedList_removeTail(LinkedList* list) {
	DEBUG("[LinkedList_removeTail]\n");
// DEBUG("1\n");
	if(list->tail == NULL) return EXIT_SUCCESS;
printf("Removing tail: %s\n", list->tail->value);
// DEBUG("2\n");
	list->totalSpanSizeInBytes -= list->tail->numCharacters;
// DEBUG("3\n");

	ListElement* secondToLastElement = list->tail->previous; // Can be NULL, no problemo
// DEBUG("4\n");
	// free(list->tail->value); // Goodbye, cruel world
// DEBUG("5\n");
	free(list->tail); // The king is dead
// DEBUG("6\n");
	list->tail = secondToLastElement; // Long live the king

	list->length--;

	return EXIT_SUCCESS;
}

size_t LinkedList_clear(LinkedList* list) {
	size_t numRemovedElements = 0;

	while(list->tail != NULL) {
		LinkedList_removeTail(list);
		numRemovedElements++;
	}

	return numRemovedElements;
}

int LinkedList_destroy(LinkedList* list) {
	DEBUG("[LinkedList_destroy]\n");
	LinkedList_clear(list);
	free(list);

	return EXIT_SUCCESS;
}

int LinkedList_insert(LinkedList* list, String span) {
	DEBUG("[LinkedList_insert]\n");

	if(list == NULL) return EXIT_FAILURE;

	ListElement* element = ListElement_Allocate();

	element->previous = list->tail; // Doesn't matter if it's NULL, still works
	element->value = span;
	element->numCharacters = strlen(span) + 1;
	list->tail = element;

	list->totalSpanSizeInBytes += element->numCharacters;
	list->length++;

	return EXIT_SUCCESS;
}

String LinkedList_toString(LinkedList* list, String buffer) {
	DEBUG("[LinkedList_toString]\n");

	if(list->tail == NULL) return buffer;

	ListElement* element = list->tail;
	printf("list->totalSpanSizeInBytes: %d\n", list->totalSpanSizeInBytes);
	size_t nextFreeIndex = list->totalSpanSizeInBytes - element->numCharacters;
	while(element != NULL) {
		String span = element->value;
		DEBUG("Copying span: %s\n", span);
		for(int i = 0; i< element->numCharacters; i++) {
		//DEBUG("nextFreeindex: %d\ni: %d\nCopying character: %c\n", nextFreeIndex, i, span[i]);
			buffer[nextFreeIndex + i] = span[i];
		}
		DEBUG("Buffer contents so far: %s\n", buffer);
		element = element->previous;
		if(element != NULL) nextFreeIndex -= element->numCharacters;
		// LinkedList_removeTail(list); // We've buffered it, no need to keep it
	}

	return buffer;
}

int LinkedList_dump(LinkedList* list) {
	DEBUG("[LinkedList_dump]\n");

	if(list == NULL) return EXIT_FAILURE; // Don't segfault if unintialized
	if(list->length <=0 ) return EXIT_SUCCESS; // Don't print random garbage data if unitialized (information disclosure)

	String buffer = String_Allocate(list->totalSpanSizeInBytes);
	memset(buffer, 0, list->totalSpanSizeInBytes);

	printf("Length: %d\n", list->length);
	printf("Characters: %d\n", list->totalSpanSizeInBytes);
	LinkedList_toString(list, buffer);
	printf("String: %s\n", buffer);
	free(buffer);

	return EXIT_SUCCESS;
}