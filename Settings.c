#define ENABLE_DEBUG_MODE 1
#define DEBUG(fmt, ...) \
     do { if (ENABLE_DEBUG_MODE) printf(fmt, __VA_ARGS__); } while (0)
