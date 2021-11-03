#define ENABLE_DEBUG_MODUE 1
#define DEBUG(fmt, ...) \
     do { if (ENABLE_DEBUG_MODUE) printf(fmt, __VA_ARGS__); } while (0)
