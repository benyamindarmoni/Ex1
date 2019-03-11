#!/bin/bash

cd $1
make
compile=$?
if [ "$compile" -gt "0" ] 
then
echo "Compilation fail    Memory leaks fail       Tread race fail "
echo    1                1                  1
exit 7



else
valgrind --leak-check=full -v ./$2&>outval.txt>&1
 grep -q "ERROR SUMMARY: 0 errors"  outval.txt

if [  $? -eq "0" ] ; then
        memory=0
else
        memory=1
fi

valgrind --tool=helgrind ./$2&>outhel.txt>&1
grep -q "ERROR SUMMARY: 0 errors" outhel.txt
if [ $? -eq "0" ] ; then
        race=0
else
      race=1
fi





if [ $memory -eq "0" ]&&[$race -eq "0"] ; then
      exit 0
      elif [ $memory -eq "0" ]&&[$race -eq "1"]; then
       exit 1
   elif [ $memory -eq "1" ]&&[$race -eq "0"]; then
       exit 2
        else
       exit 3
      fi



  
fi
