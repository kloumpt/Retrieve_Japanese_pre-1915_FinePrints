#!/bin/bash

output_folder=`pwd`"/output/"
mkdir -p "$output_folder"

list_page_prefix='https://www.loc.gov/collections/japanese-fine-prints-pre-1915/?sp='
list_page_suffix='&st=list'


for page_num in {0..10000}
do
	echo "page $page_num"
	links=`curl -s "$list_page_prefix$page_num$list_page_suffix" | grep 'item-description-title' -A 2 | grep href | awk 'BEGIN {FS="'"'"'"} {print $2}'`
	if [ $? -eq 0 ]; then
		echo "Getting $page_num"
	else
		echo "Failed to get page $page_num"
		continue
	fi
	
	for link in $links
	do
		name=`echo "$link" | awk 'BEGIN{FS="/"}{print $(NF-1)}'`
		echo "$name"
		
		echo "$link"
		file_url=`curl -s "$link" | grep 'og:image:secure_url' | grep 'v.jpg"' | awk 'BEGIN {FS="\""} {print $4; exit}'`
		echo "$file_url"
		wget "$file_url" -O "$output_folder/$name.jpg" 1>/dev/null 2>> log.txt
	done
done	
	
