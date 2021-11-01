#include <stdlib.h>

typedef char* String;

typedef struct ListElement{
	struct ListElement* previous;
	String value;
} ListElement;

typedef struct {
	size_t length;
	ListElement* tail;
} LinkedList;

LinkedList* LinkedList_new() {
	LinkedList* list = malloc(sizeof(LinkedList));
	list->tail = NULL;
	list->length = 0;
	return list;
}

int LinkedList_removeTail(LinkedList* list) {
	if(list->tail == NULL) return EXIT_SUCCESS;

	ListElement* secondToLastElement = list->tail->previous; // Can be NULL, no problemo
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
	list->tail = element;

	list->length++;

	return EXIT_SUCCESS;
}

String LinkedList_toString(LinkedList* list) {
	if(list->tail == NULL) return "";

	return "TODO";
}

void LinkedList_dump(LinkedList* list) {
	printf("Length: %s\n%s\n", list->length, LinkedList_toString(list));
}
