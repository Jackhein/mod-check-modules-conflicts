#/usr/bin/sh

echo "SQL updates:"
declare -A TABLES
read -p "     Host of database:"$'\n' HOST
read -p "     User of database:"$'\n' USER
read -p "     Password of database:"$'\n' PSWD
read -p "     Auth table:"$'\n' TABLES["auth"]
read -p "     World table:"$'\n' TABLES["world"]
read -p "     Character table:"$'\n' TABLES["character"]

cd ..
echo "Search for sql updates in modules:"
for MODULE_NAME in $(ls mod-*/sql/{auth,character,world} 2>/dev/null | grep .*: | sed -e 's/\(\/[^\/]*\)*//g' | sort | uniq); do
  echo ${MODULE_NAME}
  for TABLE_NAME in $(ls ${MODULE_NAME}/sql/{auth,character,world} 2>/dev/null | grep .*: | sed -e 's/\([^\/]*\/\)*\|://g' | sort | uniq); do
    for SQL in $(find modules/${MODULE_NAME}/sql/*world*/ -type f -name '*.sql'); do
      echo "mysql -u${USER} -h${HOST} -D${TABLES[${TABLE_NAME}]} -p${PSWD} < ${SQL}"
    done;
  done;
done;


#  for TABLES_NAME in $(ls ${MODULE_NAME}/{auth,character,world}/*.sql 2>/dev/null | sed -e 's/\([^\/]\|\\\/\)*\/\|.json$\|.csv$//g'); do
#    while true; do
#      read -p "     Apply sql update ${SQL_NAME} for table ${}found in ${MODULE_NAME}? Y/n"$'\n' yn
#      case $yn in
#        [Yy]* ) git apply --ignore-space-change --ignore-whitespace modules/${MODULE_NAME}/${PATCH_NAME}.patch; break;;
#        [Nn]* ) break;;
#        * ) echo "Please answer yes or no.";;
#      esac;
#    done;
#  done;
#done;