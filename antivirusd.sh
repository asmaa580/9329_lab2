#!/bin/bash
dir="$1"
malicious_dir="$2"
interval_secs="$3"

mkdir -p "$malicious_dir"

if [ ! -d "$dir" ] 
then 
    echo "$dir is not found"
    exit 1
fi    

scan (){
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
}




scan
ls -l "$dir" > directory-info.last
while true
do
    sleep "$interval_secs"
    ls -l "$dir" > directory-info.new

    if cmp -s directory-info.last directory-info.new
    then
        echo "no changes occured"
    else
        scan
        ls -l "$dir" > directory-info.last
    fi
    done