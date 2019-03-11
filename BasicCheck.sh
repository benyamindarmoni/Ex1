#!/bin/bash
running=$2
file=$1
cd $file
make
compile=$?

if [ "$compile" -gt "0" ];then

echo "Compilation fail    Memory leaks fail       Thread race fail "

exit 7
fi

valgrind --leak-check=full -v ./$running&>outval.txt>&1
 grep -q "ERROR SUMMARY: 0 errors"  outval.txt
isval=$?


valgrind --tool=helgrind ./$running&>outhel.txt>&1
grep -q "ERROR SUMMARY: 0 errors" outhel.txt
ishel=$?

if [ "$isval" -eq 0 ] && [ "$ishel" -eq 0 ]
then
    echo "Compilation pass    Memory leaks pass       Thread race pass "
     exit 0
elif [ "$isval" -eq 0 ] && [ "$ishel" -eq 1 ]
then 

      echo "Compilation pass    Memory leaks pass       Thread race fail "
      exit 1
     elif [ "$isval" -eq 1 ] && [ "$ishel" -eq 0 ]
then 
 echo "Compilation pass    Memory leaks fail       Thread race pass "
 exit 2
     
else 
 echo "Compilation pass    Memory leaks fail       Thread race fail "
       exit 3
fi

  
