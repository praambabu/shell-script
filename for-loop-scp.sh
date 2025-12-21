#!/bin/bash

new="/tmp/AA"

mkdir -p "$new"

for i in $(cat "servers.txt")
do
    hostfile="$new/$i"
    
    scp $i:/tmp/up "$hostfile"

done
