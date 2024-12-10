#include <stdio.h>
#include <stdlib.h>
#include "errmsg.h"
#include "io.h"
#include "transpiler.h"

/* path to source file */
static const char *source_path = NULL;
/* path to target file */
static const char *target_path = NULL;
/* parsed source file */
static struct parsed_file *source_file = NULL;

/* entry point of the program */
int main(int argc, char **argv){
    /* exit code of the program */
    int exit_code = EXIT_SUCCESS;

    /* show usage message on too few arguments */
    if(argc < 3){
        PRINTERR("too few arguments");
        printf("Usage:\n");
        printf(" %s [source] [target]  | Compiles [source] to [target]\n", argv[0]);
        exit_code = EXIT_FAILURE;
        goto _clean_and_exit;
    }

    /* set source_path and target_path */
    source_path = argv[1];
    target_path = argv[2];

    /* parse source file */
    source_file = parse_source(source_path);
    if(!source_file){
        PRINTERR("failed to parse source_path");
        exit_code = EXIT_FAILURE;
        goto _clean_and_exit;
    }

    /* transpile */
    if(transpile(source_file, target_path)){
        PRINTERR("failed to transpile source_file");
        exit_code = EXIT_FAILURE;
        goto _clean_and_exit;
    }

    /* clean and exit */
   _clean_and_exit:
    if(source_file){
        parsed_file_free(source_file);
        free(source_file);
        source_file = NULL;
    }
    exit(exit_code);
}
