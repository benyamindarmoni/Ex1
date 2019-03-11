#!/bin/bash
running=$2
file=$1
cd $file
make
compile=$?

if [ "$compile" -gt "0" ];then

echo "Compilation. Memory leaks. Thread race  "
echo "fail. fail. fail"
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
    echo "Compilation.  Memory leaks.  Thread race  "
      echo "pass. pass. pass"
     exit 0
elif [ "$isval" -eq 0 ] && [ "$ishel" -eq 1 ]
then 

      echo "Compilation.  Memory leaks.  Thread race  "
      echo "pass. pass. fail"
      exit 1
     elif [ "$isval" -eq 1 ] && [ "$ishel" -eq 0 ]
then 
 echo "Compilation. Memory leaks.  Thread race pass "
 echo "pass. fail. pass"
 exit 2
     
else 
 echo "Compilation. Memory leaks.  Thread race pass "
 echo "fail. fail. fail"
       exit 3
fi

  
