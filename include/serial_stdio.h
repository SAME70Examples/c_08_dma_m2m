#ifndef _SERIAL_STDIO_H
#define _SERIAL_STDIO_H

#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>

void serial_puts(void (*p_getc)(char), const char * pString);

void serial_printf(void (*p_puts)(const char *), const char * format, ...)
    __attribute__ ((format (printf, 2, 3)));

#endif
