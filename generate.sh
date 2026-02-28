#!/usr/bin/env bash

wget https://raw.githubusercontent.com/knotinfo-org/assets/main/knotinfo_3d-coordinates.csv.tar.gz
tar -xzf knotinfo_3d-coordinates.csv.tar.gz
infile="./3d-coordinates.csv"
lines=$(wc -l <"$infile")
current=0

html="<!DOCTYPE html><html><head><meta charset="utf-8"><title>Knotapi</title></head><body><ul>"

while IFS=',' read -r col1 col2 col3 col4; do
	echo "Processing $col1 ($((++current))/$lines)"
	# skip empty lines
	[ -z "$col1" ] && continue

	html="$html<li><a href='$col1.json'>$col1.json</a> <a href='$col1.csv'>$col1.csv</a></li>"

	# create file named after first column
	# and write the third column as content
	printf '%s\n' "${col4//;/,}" >"$col1.json"
	printf '%s\n' "${col4//;/,}" | tr -d '[]' | awk -F',' '{for(i=1;i<=NF;i+=3) print $i","$(i+1)","$(i+2)}' >"$col1.csv"
done <"$infile"

html="$html</ul></body></html>"
echo "$html" >index.html
