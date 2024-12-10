#include "transpiler.h"

#include <stdio.h>
#include <stdlib.h>
#include "errmsg.h"

/* max amount of paths in stack for transpilation */
#ifndef TRANS_STACK_SIZE
    #define TRANS_STACK_SIZE 256
#endif
/* maximum size of a string representation returned by path_end_to_label() */
#ifndef LABEL_MAX_SIZE
    #define LABEL_MAX_SIZE 32
#endif

/* does a modulus operation in the programming way, not the mathematical way */
#define RMOD(a, b) (((a % b) + b) % b)

/* info about a path end */
struct path_end{
    /* direction of the path end */
    enum { D_NORTH=0, D_EAST=1, D_SOUTH=2, D_WEST=3 } dir;
    /* row of the path end */
    int row;
    /* column of the path end */
    int col;
};

/* converts path_end to a string representation usable as a c label */
/* returns pointer to string representation on success, NULL on failure */
static char *path_end_to_label(const struct path_end *path_end);

/* transpiles parsed_file into ansi c at target_path */
/* returns 0 on success, 1 on failure */
int transpile(const struct parsed_file *parsed_file, const char *target_path){
    /* return value of the function */
    int exit_code = 0;
    /* target file written to */
    FILE *f = NULL;
    /* stack used for transpilation */
    struct path_end trans_stack[TRANS_STACK_SIZE] = {0};
    /* current point in trans_stack */
    int trans_stack_pointer = 0;
    /* map of which labels are already processed or will be processed */
    char (**processed)[4] = NULL;

    { /* allocate and initialize processed */
        /* current processed sub addressed */
        int i;

        processed = calloc(parsed_file->rows, sizeof(void *)); /* clangd, why do u scream at me for `sizeof(*processed)`, meaning i now have to use some generic pointer? */
        if(!processed){
            PRINTERR("failed to allocate processed");
            exit_code = 1;
            goto _clean_and_exit;
        }

        /* allocate and assign subs */
        for(i = 0; i < parsed_file->rows; ++i){
            processed[i] = calloc(parsed_file->columns, sizeof(**processed));
            if(!processed[i]){
                PRINTERR("failed to allocate a sub of processed");
                exit_code = 1;
                goto _clean_and_exit;
            }
            /* should be initialized to all false already, cause of calloc() */
        }
    }

    /* open f */
    f = fopen(target_path, "w");
    if(!f){
        PRINTERR("failed to open target_path for writing");
        exit_code = 1;
        goto _clean_and_exit;
    }

    /* write default start stuff to f */
    fprintf(f, "#include <stdio.h>\n");
    fprintf(f, "#include <stdlib.h>\n");
    fprintf(f, "#include <stdint.h>\n");
    fprintf(f, "#ifndef ARR_SIZE\n");
    fprintf(f, "#define ARR_SIZE 256\n");
    fprintf(f, "#endif\n");
    fprintf(f, "int main(void){\n");
    fprintf(f, "    uint8_t a[ARR_SIZE] = {0};\n");
    fprintf(f, "    int i = ARR_SIZE / 2;\n");

    { /* find start and do everything for that */
        /* currently addressed row */
        int row;
        /* currently addressed column */
        int col;
        /* path end of start */
        struct path_end start;

        for(row = 0; row < parsed_file->rows; ++row){
            for(col = 0; col < parsed_file->columns; ++col){
                if(parsed_file->data[row][col] == '$') goto _found_start;
            }
        }
        /* start was not found */
        PRINTERR("could not find start ('$') in parsed_file");
        exit_code = 1;
        goto _clean_and_exit;

        /* start was found */
       _found_start:
        start.row = row;
        start.col = col;
        start.dir = D_EAST;
        
        { /* add `goto start;` statement */
            char *start_label = path_end_to_label(&start);
            if(!start_label){
                PRINTERR("failed to get start_label from start");
                exit_code = 1;
                goto _clean_and_exit;
            }
            fprintf(f, "    goto %s;\n", start_label);
            free(start_label);
        }

        /* push start to stack (as first element to be processed) */
        trans_stack[trans_stack_pointer] = start;
        processed[start.row][start.col][start.dir] = 1;
    }

    /* process path_ends in trans_stack until there are no more */
    while(trans_stack_pointer >= 0){
        /* path_end currently addressed */
        struct path_end path_end = trans_stack[trans_stack_pointer--];

        { /* insert label */
            char *label = path_end_to_label(&path_end);
            if(!label){
                PRINTERR("failed to get label from path_end");
                exit_code = 1;
                goto _clean_and_exit;
            }
            fprintf(f, "   %s:\n", label);
            free(label);
        }

        { /* process what the command does */
            switch(parsed_file->data[path_end.row][path_end.col]){
                case '#':
                    fprintf(f, "    exit(0);\n");
                    goto _early_continue;
                case '+':
                    fprintf(f, "    ++a[i];\n");
                    break;
                case '-':
                    fprintf(f, "    --a[i];\n");
                    break;
                case '{':
                    fprintf(f, "    --i;\n");
                    break;
                case '}':
                    fprintf(f, "    ++i;\n");
                    break;
                case '.':
                    fprintf(f, "    putchar(a[i]);\n");
                    break;
                case ',':
                    fprintf(f, "    a[i] = getchar();\n");
                    break;
                #define ADD_IF_NOT_PROCESSED(meow)                \
                    if(!processed[meow.row][meow.col][meow.dir]){  \
                        trans_stack[++trans_stack_pointer] = meow;  \
                        processed[meow.row][meow.col][meow.dir] = 1; \
                    }
                #define COND_PATH_END(rowmod, colmod, dirmod)                            \
                    { /* add potential path to stack and logic */                         \
                        /* path end gone too if a[i] != 0 */                               \
                        struct path_end if_not_0_end;                                       \
                        if_not_0_end.row = RMOD(path_end.row + rowmod, parsed_file->rows);   \
                        if_not_0_end.col = RMOD(path_end.col + colmod, parsed_file->columns); \
                        if_not_0_end.dir = dirmod;                                             \
                        { /* create conditional goto statement */                               \
                            /* label of if_0_end */                                              \
                            char *if_not_0_end_label = path_end_to_label(&if_not_0_end);          \
                            if(!if_not_0_end_label){                                               \
                                PRINTERR("failed to get if_not_0_end_label from if_not_0_end");     \
                                exit_code = 1;                                                       \
                                goto _clean_and_exit;                                                 \
                            }                                                                          \
                            fprintf(f, "    if(a[i] != 0) goto %s;    \n", if_not_0_end_label);         \
                            free(if_not_0_end_label);                                                    \
                        }                                                                                 \
                        /* add if_not_0_end to trans_stack */                                              \
                        ADD_IF_NOT_PROCESSED(if_not_0_end);                                                 \
                    }
                case '^':
                    COND_PATH_END(-1, 0, D_NORTH);
                    break;
                case 'v':
                    COND_PATH_END(+1, 0, D_SOUTH);
                    break;
                case '<':
                    COND_PATH_END(0, -1, D_WEST);
                    break;
                case '>':
                    COND_PATH_END(0, +1, D_EAST);
                    break;
                #undef COND_PATH_END
            }
        }

        { /* process where instruction pointer will be next and add that */
            /* new path end to be added */
            struct path_end pe;
            switch(parsed_file->data[path_end.row][path_end.col]){
                #define ADD_GOTO(meow)                             \
                    { /* blah blah blah */                          \
                        char *label = path_end_to_label(&meow);      \
                        if(!label){                                   \
                            PRINTERR("failed to get label from meow"); \
                            exit_code = 1;                              \
                            goto _clean_and_exit;                        \
                        }                                                 \
                        fprintf(f, "    goto %s;\n", label);               \
                        free(label);                                        \
                    }
                default:
                    { /* add path to stack and logic */
                        switch(path_end.dir){
                            case D_NORTH:
                                pe.row = RMOD(path_end.row - 1, parsed_file->rows);
                                pe.col = path_end.col;
                                pe.dir = D_NORTH;
                                break;
                            case D_SOUTH:
                                pe.row = RMOD(path_end.row + 1, parsed_file->rows);
                                pe.col = path_end.col;
                                pe.dir = D_SOUTH;
                                break;
                            case D_WEST:
                                pe.row = path_end.row;
                                pe.col = RMOD(path_end.col - 1, parsed_file->columns);
                                pe.dir = D_WEST;
                                break;
                            case D_EAST:
                                pe.row = path_end.row;
                                pe.col = RMOD(path_end.col + 1, parsed_file->columns);
                                pe.dir = D_EAST;
                                break;
                        }
                        ADD_GOTO(pe);
                        ADD_IF_NOT_PROCESSED(pe);
                    }
                    break;
                case '!':
                    { /* add path to stack and logic */
                        switch(path_end.dir){
                            case D_NORTH:
                                pe.row = RMOD(path_end.row - 2, parsed_file->rows);
                                pe.col = path_end.col;
                                pe.dir = D_NORTH;
                                break;
                            case D_SOUTH:
                                pe.row = RMOD(path_end.row + 2, parsed_file->rows);
                                pe.col = path_end.col;
                                pe.dir = D_SOUTH;
                                break;
                            case D_WEST:
                                pe.row = path_end.row;
                                pe.col = RMOD(path_end.col - 2, parsed_file->columns);
                                pe.dir = D_WEST;
                                break;
                            case D_EAST:
                                pe.row = path_end.row;
                                pe.col = RMOD(path_end.col + 2, parsed_file->columns);
                                pe.dir = D_EAST;
                                break;
                        }
                        ADD_GOTO(pe);
                        ADD_IF_NOT_PROCESSED(pe);
                    }
                    break;
                case '/':
                    { /* add path to stack and logic */
                        switch(path_end.dir){
                            case D_NORTH:
                                pe.row = path_end.row;
                                pe.col = RMOD(path_end.col + 1, parsed_file->columns);
                                pe.dir = D_EAST;
                                break;
                            case D_SOUTH:
                                pe.row = path_end.row;
                                pe.col = RMOD(path_end.col - 1, parsed_file->columns);
                                pe.dir = D_WEST;
                                break;
                            case D_WEST:
                                pe.row = RMOD(path_end.row + 1, parsed_file->rows);
                                pe.col = path_end.col;
                                pe.dir = D_SOUTH;
                                break;
                            case D_EAST:
                                pe.row = RMOD(path_end.row - 1, parsed_file->rows);
                                pe.col = path_end.col;
                                pe.dir = D_NORTH;
                                break;
                        }
                        ADD_GOTO(pe);
                        ADD_IF_NOT_PROCESSED(pe);
                    }
                    break;
                case '\\':
                    { /* add path to stack and logic */
                        switch(path_end.dir){
                            case D_NORTH:
                                pe.row = path_end.row;
                                pe.col = RMOD(path_end.col - 1, parsed_file->columns);
                                pe.dir = D_WEST;
                                break;
                            case D_SOUTH:
                                pe.row = path_end.row;
                                pe.col = RMOD(path_end.col + 1, parsed_file->columns);
                                pe.dir = D_EAST;
                                break;
                            case D_WEST:
                                pe.row = RMOD(path_end.row - 1, parsed_file->rows);
                                pe.col = path_end.col;
                                pe.dir = D_NORTH;
                                break;
                            case D_EAST:
                                pe.row = RMOD(path_end.row + 1, parsed_file->rows);
                                pe.col = path_end.col;
                                pe.dir = D_SOUTH;
                                break;
                        }
                        ADD_GOTO(pe);
                        ADD_IF_NOT_PROCESSED(pe);
                    }
                    break;
                #undef ADD_GOTO
            }
        }

       _early_continue:;
        #undef ADD_IF_NOT_PROCESSED
    }

    /* write default end stuff to f */
    fprintf(f, "}\n");

    /* clean and exit */
   _clean_and_exit:
    if(f) fclose(f);
    if(processed){
        /* index of sub currently addressed */
        int i;

        /* free subs */
        for(i = 0; i < parsed_file->rows; ++i){
            if(processed[i]) free(processed[i]);
        }

        /* free processed itself */
        free(processed);
    }
    return exit_code;
}

/* converts path_end to a string representation usable as a c label */
/* returns pointer to string representation on success, NULL on failure */
static char *path_end_to_label(const struct path_end *path_end){
    /* return value of the function */
    char *outp = NULL;

    /* allocate outp */
    outp = calloc(LABEL_MAX_SIZE + 1, sizeof(*outp));
    if(!outp){
        PRINTERR("failed to allocate string representation");
        goto _clean_and_exit;
    }

    { /* sprintf stuff */
        /* character representing direction of path_end */
        char dir_c;

        switch(path_end->dir){
            case D_NORTH:
                dir_c = 'N';
                break;
            case D_SOUTH:
                dir_c = 'S';
                break;
            case D_EAST:
                dir_c = 'E';
                break;
            case D_WEST:
                dir_c = 'W';
                break;
        }
        sprintf(outp, "_%i_%i_%c", path_end->row, path_end->col, dir_c);
    }

    /* clean and exit */
   _clean_and_exit:
    return outp;
}
