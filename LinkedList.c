#include <stdlib.h>

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
	LinkedList* list = malloc(sizeof(LinkedList));
	list->tail = NULL;
	list->length = 0;
	list->totalSpanSizeInBytes = 0;
	return list;
}

int LinkedList_removeTail(LinkedList* list) {
	if(list->tail == NULL) return EXIT_SUCCESS;

	list->totalSpanSizeInBytes -= list->tail->numCharacters;

	ListElement* secondToLastElement = list->tail->previous; // Can be NULL, no problemo
	free(list->tail->value); // Goodbye, cruel world
	free(list->tail); // The king is dead
	list->tail = secondToLastElement; // Long live the king

	list->length--;

	return EXIT_SUCCESS;
}

int LinkedList_destroy(LinkedList* list) {
	while(list->tail != NULL) {
		LinkedList_removeTail(list);
	}
	free(list);

	return EXIT_SUCCESS;
}

int LinkedList_insert(LinkedList* list, String span) {
	ListElement* element = malloc(sizeof(ListElement));

	element->previous = list->tail; // Doesn't matter if it's NULL, still works
	element->value = span;
	element->numCharacters = sizeof(span);
	list->tail = element;

	list->totalSpanSizeInBytes += element->numCharacters;
	list->length++;

	return EXIT_SUCCESS;
}

String LinkedList_toString(LinkedList* list, String buffer) {
	if(list->tail == NULL) return buffer;

	size_t nextFreeIndex = 0;
	while(list->tail != NULL) {
		String span = list->tail->value;
		for(int i=0; i < sizeof(span); i++) {
			buffer[nextFreeIndex + i] = span[i];
		}
		nextFreeIndex += sizeof(span);
	}

	return buffer;
}

void LinkedList_dump(LinkedList* list) {
	String buffer = malloc(list->totalSpanSizeInBytes);
	printf("Buffered string: %s", buffer);

	printf("Length: %s\nCharacters: %d\n%s\n", list->length, list->totalSpanSizeInBytes, LinkedList_toString(list, buffer));
	free(buffer);
}
