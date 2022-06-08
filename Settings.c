#define ENABLE_DEBUG_MODE 1
#define DEBUG(formatString, ...) \
	do { \
		if (ENABLE_DEBUG_MODE) { \
			printf(formatString, __VA_ARGS__); \
			printf("\t@ %s:%i\n", __FILE__, __LINE__); \
		} \
	} while (0)
