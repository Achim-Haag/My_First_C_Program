/*
    Separate source to c't 25/2024 (8.11.24) p.66,
    as external source included in the main program
    Contains some definitions for precompile and compiler

*/

#ifndef __WORDS_H__
#define __WORDS_H__

#define WORD_LENGTH (5)

// at this point, the array in the other external source (array "words" in source words.c)
// is defined, so words.c has to be linked to the main program !
extern const char* words[];

#endif  // __WORDS_H_