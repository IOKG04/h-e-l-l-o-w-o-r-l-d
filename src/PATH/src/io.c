#include "io.h"

#include <stdio.h>
#include <stdlib.h>
#include "errmsg.h"

/* reads and parses source file */
/* returns pointer to parsed source on success, NULL on failure */
struct parsed_file *parse_source(const char *source_path){
    /* output of the function */
    struct parsed_file *outp = NULL;
    /* stream pointed to by source_path */
    FILE *f = NULL;
    /* amount of rows in source */
    int rows = 0;
    /* amount of columns in source */
    int columns = 0;

    /* open file */
    f = fopen(source_path, "r");
    if(!f){
        PRINTERR("failed to open source_path for reading");
        goto _clean_and_exit;
    }

    { /* get amount of rows and columns */
        /* current character read */
        int c;
        /* amount of columns so far read in current row */
        int current_columns = 0;
        
        while((c = fgetc(f)) != EOF){
            /* handle row end */
            if(c == '\n'){
                ++rows;
                if(current_columns > columns) columns = current_columns;
                current_columns = 0;
            }
            /* handle else */
            else{
                ++current_columns;
            }
        }

        /* rewind source file so it can be used again later */
        rewind(f);
    }

    /* allocate and assign outp */
    outp = calloc(1, sizeof(*outp));
    if(!outp){
        PRINTERR("failed to allocate parsed file");
        goto _clean_and_exit;
    }
    outp->rows    = rows;
    outp->columns = columns;

    /* allocate and assign subs */
    outp->data = calloc(rows, sizeof(*(outp->data)));
    if(!outp->data){
        PRINTERR("failed to allocate rows in parsed file");
        free(outp);
        outp = NULL;
        goto _clean_and_exit;
    }
    { /* allocate sub-subs */
        /* index in subs currently addressed */
        int i;

        for(i = 0; i < rows; ++i){
            outp->data[i] = calloc(columns, sizeof(**(outp->data)));
            if(!outp->data[i]){
                /* free everything else already allocated on error */
                PRINTERR("failed to allocate specific row in parsed file");
                for(i = i - 1; i >= 0; --i){
                    free(outp->data[i]);
                }
                free(outp->data);
                free(outp);
                outp = NULL;
                goto _clean_and_exit;
            }
        }
    }

    { /* assign sub-subs */
        /* current row addressed */
        int crow;
        /* current column addressed */
        int ccol;

        for(crow = 0; crow < rows; ++crow){
            /* character currently read */
            int c;

            ccol = 0;
            while((c = fgetc(f)) != '\n' && c != EOF){
                outp->data[crow][ccol] = c;
                ++ccol;
            }
            for(ccol = ccol; ccol < columns; ++ccol){
                outp->data[crow][ccol] = ' ';
            }
        }
    }

    /* clean and exit */
   _clean_and_exit:
    if(f) fclose(f);
    return outp;
}
/* frees subs of f */
void parsed_file_free(struct parsed_file *f){
    { /* free sub-subs */
        /* index of current sub-sub addressed */
        int i;

        for(i = 0; i < f->rows; ++i){
            free(f->data[i]);
        }
    }

    /* free sub */
    free(f->data);
}
