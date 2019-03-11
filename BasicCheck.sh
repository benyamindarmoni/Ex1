#!/bin/bash

cd $1
make&>makeout.txt>&1
compile=$?
echo $compile
if [ "$compile" -gt "0" ] 
then
echo "Compilation    Memory leaks        Thread race "
echo    0                 0                  0
else
valgrind --leak-check=full -v ./$2&>outval.txt>&1
 grep -q "ERROR SUMMARY: 0 errors"  outval.txt

if [  $? -eq "0" ] ; then
        memory=1
else
        memory=0
fi

valgrind --tool=helgrind ./$2&>outhel.txt>&1
grep -q "ERROR SUMMARY: 0 errors" outhel.txt
if [ $? -eq "0" ] ; then
        race=1
else
      race=0
fi

 echo "Compilation    Memory leaks        Thread race "
 echo      1             $memory             $race
 

  
fi
