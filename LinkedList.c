#include <stdlib.h>
#include <string.h>

#define ENABLE_DEBUG_MODUE 1
#define DEBUG(fmt, ...) \
     do { if (ENABLE_DEBUG_MODUE) printf(fmt, __VA_ARGS__); } while (0)

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

LinkedList* LinkedList_new() {
	DEBUG("[LinkedList_new]\n");

	LinkedList* list = malloc(sizeof(LinkedList));
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

int LinkedList_destroy(LinkedList* list) {
	DEBUG("[LinkedList_destroy]\n");
	while(list->tail != NULL) {
		LinkedList_removeTail(list);
	}
	free(list);

	return EXIT_SUCCESS;
}

int LinkedList_insert(LinkedList* list, String span) {
	DEBUG("[LinkedList_insert]\n");

	if(list == NULL) return EXIT_FAILURE;

	ListElement* element = malloc(sizeof(ListElement));

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
		DEBUG("nextFreeindex: %d\ni: %d\nCopying character: %c\n", nextFreeIndex, i, span[i]);
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

	String buffer = malloc(list->totalSpanSizeInBytes);
	memset(buffer, 0, list->totalSpanSizeInBytes);

	printf("Length: %d\n", list->length);
	printf("Characters: %d\n", list->totalSpanSizeInBytes);
	LinkedList_toString(list, buffer);
	printf("String: %s\n", buffer);
	free(buffer);

	return EXIT_SUCCESS;
}