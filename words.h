/*
    Separate source to c't 25/2024 (8.11.24) p.66,
    as external source included in the main program
    Contains some definitions for precompile and compiler

*/

#ifndef __WORDS_H__
#define __WORDS_H__

#define WORD_LENGTH (5)
#define NUM_WORDS (7)       // My list of words and the end-of-list NULL pointer !

// at this point, the array in the other external source (array "words" in source words.c)
// is defined, so words.c has to be linked to the main program !
extern const char words[NUM_WORDS][WORD_LENGTH+1];

#endif  // __WORDS_H_