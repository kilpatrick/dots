#!/bin/bash

target_num_len=5
prepend_char="0"
str_label="example_"
starting_num=0
count=$starting_num

for file in *.jpg; do

    str_num="${count}"
    str_num_size=${#str_num}

    while [ $str_num_size -lt $target_num_len ]; do
        str_num="${prepend_char}${str_num}"
        str_num_size=${#str_num}
    done

    # Saved in Test Mode: Uncomment mv command to use.
    echo "renaming ${file} as ${str_label}${str_num}.jpg"
    # mv "${file}" "${str_label}${str_num}.jpg"
    ((count++))
done

let files_changed="${count} - ${starting_num}"
echo "Done. Renamed ${files_changed} files."
