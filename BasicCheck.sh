#!/bin/bash

cd $1
make
compile=$?

if [ "$compile" -gt "0" ];then

echo "Compilation fail    Memory leaks fail       Tread race fail "

exit 7
fi

valgrind --leak-check=full -v ./$2&>outval.txt>&1
 grep -q "ERROR SUMMARY: 0 errors"  outval.txt
isval=$?


valgrind --tool=helgrind ./$2&>outhel.txt>&1
grep -q "ERROR SUMMARY: 0 errors" outhel.txt
ishel=$?

if [ "$isval" -eq 0 ] && [ "$ishel" -eq 0 ]
then
  exit 0
    echo "Compilation pass    Memory leaks pass       Tread race pass "
    
elif [ "$isval" -eq 0 ] && [ "$ishel" -eq 1 ]
then 
 exit 1
      echo "Compilation pass    Memory leaks pass       Tread race fail "
     elif [ "$isval" -eq 1 ] && [ "$ishel" -eq 0 ]
then 
 exit 2
      echo "Compilation pass    Memory leaks fail       Tread race pass "
       
else 
 echo "Compilation pass    Memory leaks fail       Tread race fail "
       exit 3
fi

  
