#ifndef TRANSPILER_H__
#define TRANSPILER_H__

/* for parsed_file */
#include "io.h"

/* transpiles parsed_file into ansi c at target_path */
/* returns 0 on success, 1 on failure */
int transpile(const struct parsed_file *parsed_file, const char *target_path);

#endif
