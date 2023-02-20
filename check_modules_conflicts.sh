#/usr/bin/sh

cd ..
echo "Check conflicts in CSV update file for DBC:";
for csv in $(ls mod-*/data/dbc/*.csv | sed -e 's/\([^\/]\|\\\/\)*\///g' | sort | uniq -d); do
	echo "	Check ID duplicate for all ${csv} files";
	for dup in $(cat mod-*/data/dbc/${csv} | grep -o '^"[0-9]*"' | sort | uniq -d); do
		echo "		Duplicate ID ${dup} in:";
		grep -nH "^${dup}" mod-*/data/dbc/${csv} | sed -e 's/^/			/g';
	done;
done;
