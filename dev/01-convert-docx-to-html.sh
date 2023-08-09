#!/bin/bash

# exit if libreoffice is not installed
if ! [ -x "$(command -v libreoffice)" ]; then
    echo 'Error: libreoffice is not installed.' >&2
    exit 1
fi

for file in revisited_drafts/*.docx; do
    # replace all spaces in filenames with underscores
    mv "$file" "$(echo "$file" | sed 's/ /_/g')"
done

# convert each docx file in revisited drafts/ to html
for file in revisited_drafts/*.docx; do
    print "$file"
    pandoc -s -o "${file%.docx}.html" "$file"
    file2=$(echo "$file" | sed 's/docx/html/g')
    # export to html if file2 does not exist
    if [ ! -f "$file2" ]; then
        libreoffice --headless --convert-to html --outdir revisited_drafts/ "$file"
    fi
done
