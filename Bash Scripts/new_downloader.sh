#!/bin/bash

# Specify the input file containing the links
input_file="filelist.txt"

# Create a directory to store downloaded files if it doesn't exist
download_dir="downloaded_files"
mkdir -p "$download_dir"

# Loop through each line in the input file and download the contents
while read -r link; do
    # Check if the link contains "codefling"
    if [[ $link == *"codefling"* ]]; then
        # Extract the plugin name from the URL
        plugin_name=$(echo "$link" | sed 's/.*codefling\.com\/plugins\/\([^?]*\)?do=download/\1/')
        
        # Capitalize the plugin name and remove hyphens
        modified_plugin_name=$(echo "$plugin_name" | sed -e 's/\b\(.\)/\u\1/g' -e 's/-//g')
        
        # Construct the modified filename
        filename="${modified_plugin_name}.cs"
    else
        # Use a generic filename if "codefling" is not in the link
        filename="downloaded_file"
    fi
    
    # Use wget to download the link with the modified filename
    wget -P "$download_dir" "$link" -O "$download_dir/$filename"
done < "$input_file"

echo "Downloaded files have been saved in the $download_dir directory."

