#!/bin/bash

dir="$1"
malicious_dir="$2"
i=1
choice1=-1
choice2=-1

if [ ! -d "$dir" ]
then
    echo "$dir is not found"
    exit 1
fi

touch whitelist.txt

while(true)
do
if [ -z "$(ls -A "$malicious_dir")" ]
then
    echo "No malicious files to review."
    exit 0
fi

for file in "$malicious_dir"/*
do
    if [ -f "$file" ]
    then
        echo "$i - $(basename "$file")"
        i=$((i+1))
    fi
done


echo choose a the file number

i=1
read choice1
for file in "$malicious_dir"/*
do
    if [ -f "$file" ]
    then
    if [ "$i" -eq "$choice1" ]
    then
        break
    fi
    i=$((i+1))
    fi
done

echo "1. Restore this file
2. Permanently delete this file
3. Leave this file as-is

Choose:"

read choice2
if [ "$choice2" -eq 1 ]
then 
    cp "$file" "$dir" 
    rm "$file"
    echo $(basename "$file") >> whitelist.txt
    echo "Restored $(basename "$file")  to $dir"
    echo "Added $(basename "$file")  to whitelist"
elif [ "$choice2" -eq 2 ]
then
    rm "$file"
    echo "$(basename "$file") permenently deleted"
elif [ "$choice2" -eq 3 ]
then
    :
else 
echo "this is invalid choice"
fi
done