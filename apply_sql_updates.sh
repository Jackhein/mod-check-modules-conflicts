#/usr/bin/sh

echo "SQL updates:"
declare -A TABLES
read -p "     Host of database:"$'\n' HOST
read -p "     User of database:"$'\n' USER
read -p "     Password of database:"$'\n' PSWD
read -p "     Auth table:"$'\n' TABLES["auth"]
read -p "     Character table:"$'\n' TABLES["character"]
read -p "     World table:"$'\n' TABLES['world']

cd ..
echo "Search for sql updates in modules:"
for MODULE_NAME in $(ls mod-*/sql/{auth,character,world} 2>/dev/null | grep .*: | sed -e 's/\(\/[^\/]*\)*//g' | sort | uniq); do
  echo ${MODULE_NAME}
  for TABLE_NAME in $(ls ${MODULE_NAME}/sql/{auth,character,world} 2>/dev/null | grep .*: | sed -e 's/\([^\/]*\/\)*\|://g' | sort | uniq); do
    echo ${TABLE_NAME}
    for SQL in $(find ${MODULE_NAME}/sql/${TABLE_NAME}/ -type f -name '*.sql'); do
      while true; do
        read -p "     Apply sql update from module \"$(echo ${SQL} | sed -e 's/\([^\/]*\/\)*//g')\" for table \"${TABLES[${TABLE_NAME}]}\" found in \"${MODULE_NAME}\"? Y/n"$'\n' yn
        case $yn in
          [Yy]* ) mysql -u${USER} -h${HOST} -D${TABLES[${TABLE_NAME}]} -p${PSWD} < ${SQL}; break;;
          [Nn]* ) break;;
          * ) echo "Please answer yes or no.";;
        esac;
      done;
    done;
  done;
done;