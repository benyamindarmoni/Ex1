#!/bin/bash

cd $1
make

if [ $? -gt "0" ] ; then
       echo "Compilation fail  Memory leaks FAIL   Tread race FAIL"
        exit 7
fi

valgrind --leak-check=full --error-exitcode=1 ./$2 $@ &> /dev/null

if [ $? -eq "0" ] ; then
        memory=0
else
        memory=1
fi

valgrind --tool=helgrind --error-exitcode=1 ./$2 $@ &> /dev/null
if [ $? -eq "0" ] ; then
        race=0
else
        race=1
fi




if [ $memory -eq "0"&&$race -eq "0" ] ; then
        echo "Compilation PASS  Memory leaks PASS      thread race PASS"
        exit 0
elif [ $memory -eq "1"&&$race -eq "0" ] ; then
        echo "Compilation PASS  Memory leaks FAIL       thread race PASS"
       exit 2
elif [ $memory -eq "0"&&$race -eq "1" ] ; then
        echo "Compilation PASS  Memory leaks PASS       thread race FAIL"
       exit 1
else
        echo "Compilation PASS  Memory leaks FAIL       thread race FAIL"
        exit 3
fi
