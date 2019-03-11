#!/bin/bash
file=$1
running=$2

cd $file

make&>makeout.txt>&1
iscompile=$?
echo $compile
if [ "$compile" -gt "0" ] 
then
echo "Compilation fail    Memory leaks fail        Thread race fail "
exit 7
else
valgrind --leak-check=full -v ./$2&>outval.txt>&1
 grep -q "ERROR SUMMARY: 0 errors"  outval.txt
isval=$?
if [  $isval -eq "0" ] ; then
        memory=0
else
        memory=1
fi

valgrind --tool=helgrind ./$2&>outhel.txt>&1
grep -q "ERROR SUMMARY: 0 errors" outhel.txt
ishel=$?
if [ $ishel -eq "0" ] ; then
        race=0
else
      race=1
fi

if [$memory -eq "0" &&$race -eq "0"]; then
exit 0
fi
if [$memory -eq "0" &&$race -eq "1"]; then
exit 1
fi
if [$memory -eq "1" &&$race -eq "0"]; then
exit 2
fi
if [$memory -eq "1" &&$race -eq "1"]; then
exit 3
fi
  
fi
