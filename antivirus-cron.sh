#!/bin/bash
dir="$1"
malicious_dir="$2"
mkdir -p "$malicious_dir"

if [ ! -d "$dir" ] 
then 
    echo "$dir is not found"
    exit 1
fi    

    for file in "$dir"/*
        do
            if [ -f "$file" ]
            then
                if grep -Fxq -- "$(basename "$file")" whitelist.txt
                then
                echo "$file is whitelisted; skipping"
                continue
                fi

                if [[ "$file" =~ \.(exe|bat|vbs|scr|ps1)$ ]]
                then
                    cp "$file" "$malicious_dir"
                    rm "$file"
                    echo "$file is malicious and it is DELETED"
                    
                elif grep -q -i -E "virus|trojan|malware|worm|ransomware" "$file"
                then
                    cp "$file" "$malicious_dir"
                    rm "$file"
                    echo "$file is malicious and it is DELETED"
                fi
            fi
        done
