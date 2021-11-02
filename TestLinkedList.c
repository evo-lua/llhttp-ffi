#include "LinkedList.c"

void main() {
	printf("Testing linked list implementation...\n");

	// Dump unitialized list -> Nothing should happen
	LinkedList_dump(NULL);

	LinkedList* list = LinkedList_new();

	// Dump empty list -> It must not crash here either
	LinkedList_dump(list);

	// The most basic test for dump/tostring one can imagine
	LinkedList_insert(list, "Hello world");
	LinkedList_dump(list);
	printf("Length is now %d\n", list->length);

	LinkedList_insert(list, "New is always better");
	LinkedList_dump(list);
	printf("Length is now %d\n", list->length);
	LinkedList_removeTail(list);
	printf("Length is now %d\n", list->length);
	LinkedList_removeTail(list);
	printf("Length is now %d\n", list->length);

	// List is empty now, so removing again should fail (but not crash the application)
	LinkedList_removeTail(list);
	LinkedList_removeTail(list);
	LinkedList_removeTail(list);
	LinkedList_removeTail(list); // Should all be NOOPs


	LinkedList_insert(list, "Test123");
	LinkedList_insert(list, "Test456");
	LinkedList_insert(list, "Test789");
	String buffer = malloc(strlen("Test123") + 1);
	LinkedList_getTail(list, buffer);
	LinkedList_removeTail(list);
	printf("Buffer contents: %s\n", buffer);
	LinkedList_getTail(list, buffer);
	LinkedList_removeTail(list);
	printf("Buffer contents: %s\n", buffer);
	LinkedList_getTail(list, buffer);
	LinkedList_removeTail(list);
	printf("Buffer contents: %s\n", buffer);
	free(buffer);
}