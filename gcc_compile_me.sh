#!/usr/bin/bash
#
# Compiles the sample program Achims_C-Test_241115.exe
# Parameter:
# -v : verbose (script commands and gcc -v)
#

pgmname="Achims_C-Test_241115"
verbosity=""
#
pgmmain="Achims_C-Test_241115.c"		# Main program
pgmwords="words.c"				# Sub-program
incwords="words.h"				# Include of sub-program
execute="Achims_C-Test_241115"			# Main program executable (gcc output)

#
# Process parameters (leading colon: don't give error but wrong option as "?" and option character in $OPTARG
#
while getopts ":vh" optchar ; do
  case $optchar in
  h)
    echo "Compiles $pgmname with gcc"
    exit 4
  ;;
  v)
    echo "Verbosity mode active"
    verbosity="-v"	# Parameter for gcc
    set -xv		# Script verbosity on
  ;;
  \?)
    echo "Parameter [$OPTARG] not suppoerted, try -h"
    exit 8
  ;;
  *)
    echo "Parameter [$optchar] not implemented (should not occur)"
  ;;
  esac
done
#
# Check gcc compiler there
#
which gcc
whrc=$?
if [[ $whrc -ne 0 ]] ; then
  echo "I can't find gcc, please set your path accordingly"
  exit 8
fi

#
# Check needed files
#

pgmmain="Achims_C-Test_241115.c"		# Main program
pgmwords="words.c"				# Sub-program
incwords="words.h"				# Include of sub-program
pgmexec="Achims_C-Test_241115"			# Main program executable (gcc output)

if [[ ! -f $pgmmain ]] ; then
  echo "Missing: $pgmmain\t(Main program)"
  exit 12
fi
if [[ ! -f $pgmwords ]] ; then
  echo "Missing: $pgmwords\t(Sub-program)"
  exit 12
fi
if [[ ! -f $incwords ]] ; then
  echo "Missing: $incwords\t(Include of sub-program)"
  exit 12
fi
if [[ ! -f $pgmexec ]] ; then
  echo "Old executable $pgmexec will be removed"
  rm -iv $pgmexec
fi

#
# Call the gcc compiler (verbosity = -v or empty; -I./ = where to look for local includes)
#
echo "============================================================="
gcc $verbosity  -I./ -o $pgmexec $pgmmain $pgmwords
gccrc=$?
echo "============================================================="
echo "gcc ended with rc=$gccrc"
[[ $gccrc -ne 0 ]] && echo "Try parameter -v for verbosity" || ls -l $pgmexec
exit $gccrc
