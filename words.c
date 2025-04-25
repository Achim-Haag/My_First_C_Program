/*
    Separate source to c't 25/2024 (8.11.24) p.66,
    Contains the array of words to guess.
    Accessd from main program (wordle.c, here Achims_C-Test_241115.c) as an external array
    See also https://github.com/607011/wordle-c
    
*/
#pragma message ("***** Build " __FILE__ " at " __DATE__ " " __TIME__ "*****\n")   
// printf("***** Running %s,\nBinary build date: %s @ %s *****\n\n", argv[0], __DATE__, __TIME__);

// stddef.h defines NULL - otherwise use "nullptr" (in newer C versions intrinsic)
#include <stddef.h>


// include the structure definitions from file "words.h"
// As I typed in the source code (remebering it better ;-), it's just a subset of the original file

#include "words.h"

const char *words[] = {
    "abort", "acorn", "acryl",
    "grunz","guggu","gurks","guzzi","guzzl",
    "hanns", "heinz", "herby",
    "erwin", "erich", "emile", "erpel", "eumel",
    "sandy", "sammy", "sadie", "sofie", "susie", "suzie",
    // Reason to change the delimiter from NULL to "####"
    // 1. NULL in MSVC is part of include stddef.h
    // 2. Compare wasn't working, instead: the for-loop leads to a return to the operating system
    //      (maybe the stack overwriten ?)
//    "#####"     // marker "Last entry". Maybe a better choice: explicitly set last element via code to "#####"
    NULL
};
