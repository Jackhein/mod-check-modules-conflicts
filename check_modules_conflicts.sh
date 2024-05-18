#/usr/bin/bash

cd ..
echo "Check conflicts in DBC update file:";
for dbc in $(ls mod-*/data/dbc/*.{csv,json} 2>/dev/null | sed -e 's/\([^\/]\|\\\/\)*\/\|.json$\|.csv$//g' | sort | uniq -d); do
	echo "	Check ID duplicate for all \"${dbc}\" files";
	for dup in $(cat mod-*/data/dbc/${dbc}.{csv,json} 2>/dev/null | grep -o '"ID":[0-9]*\|^"[0-9]*"' | grep -o '[0-9]*' | sort | uniq -d); do
		echo "		Duplicate ID \"${dup}\" in:";
		grep -nHo "\"ID\":${dup}\|^\"${dup}\"" mod-*/data/dbc/${dbc}.* | sed -e 's/^\([^:]*:[^:]*\).*/			\1/g'
	done;
	echo "	Ended ID checking for all \"${dbc}\" files";
done;
