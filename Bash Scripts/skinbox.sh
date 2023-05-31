#!/bin/bash

#How to Run The SCRIPT
# ./skinbox.sh "Rust-item-main-page-in-these-double-quotes" file-name-with-ids number-of-pages

# Base URL of the Steam Workshop page
base_url="$1&p="
file=$2
pages=$3
# Loop through pages
for ((page=1; page<=$pages; page++)); do
  # Generate the URL for the current page
  url="${base_url}${page}"
  
  # Send a GET request to the URL and save the HTML content to a file
  curl -s "$url" > temp.html
  
  # Extract the item IDs from the HTML file using grep and add comma at the end of each ID
  item_ids=$(grep -o 'data-publishedfileid="[0-9]*"' temp.html | grep -o '[0-9]*' | sed 's/$/,/')
  
  # Append the item IDs to the output file on separate lines
  echo "$item_ids" >> $file.txt
  
  # Remove the temporary HTML file
  rm temp.html
done

echo "All item IDs have been successfully copied to ${file}.txt"
