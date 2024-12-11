#ifndef IO_H__
#define IO_H__

/* information of a parsed source file */
struct parsed_file{
    /* rows in file */
    int rows;
    /* columns in file */
    int columns;
    /* data of file, indexed by row first */
    char **data;
};

/* reads and parses source file */
/* returns pointer to parsed source on success, NULL on failure */
struct parsed_file *parse_source(const char *source_path);
/* frees subs of f */
void parsed_file_free(struct parsed_file *f);

#endif
