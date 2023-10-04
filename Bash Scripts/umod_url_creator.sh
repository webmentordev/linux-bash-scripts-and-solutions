#!/bin/bash

# This bash script will create the URL of all plugins in the folder
# Place this file in plugins folder and run it.
# If plugins are not from Umod then they will not be updated

directory_path=$(pwd)

output_file="output.txt"

cd "$directory_path" || exit

for file in *; do
    if [ -f "$file" ]; then
        filename="${file%.*}"
        extension="${file##*.}"
        new_filename="https://umod.org/plugins/${filename}.${extension}"
        echo "$new_filename" >> "$output_file"
    fi
done

echo "File names with the prefix have been saved to $output_file"