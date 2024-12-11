#if !defined(ERRMSG_H__)
#define ERRMSG_H__

/* necessary for fprintf() */
#include <stdio.h>

/* prints an error message */
#if defined(DEBUG)
    #define PRINTERR(errmsg) fprintf(stderr, "ERROR: %s at %s, %i\n", errmsg, __FILE__, __LINE__)
#elif defined(NDEBUG)
    #define PRINTERR(errmsg)
#else
    #define PRINTERR(errmsg) fprintf(stderr, "ERROR: %s\n", errmsg)
#endif

#endif
