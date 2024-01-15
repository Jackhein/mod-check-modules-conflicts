#/usr/bin/sh

ERR="\e[31m"
INF="\e[36m"
END="\e[0m"

declare -A DATABASES
DATABASES["auth"]="db_auth"
DATABASES["character"]="db_characters"
DATABASES["world"]="db_world"

cd ..
echo "Search for sql updates in modules:"
for MODULE_NAME in $(
  ls $(find mod-*/ -type f -name '*.sql') 2>/dev/null | grep -Eo ".*/" | sed -e 's/\/.*//g' | sort | uniq
); do
  echo -e "Current module: ${INF}${MODULE_NAME}${END}"
  for DATABASE_PATH in $(
    ls $(find ${MODULE_NAME}/ -type d -name '*sql*')/*{auth,character,world}* 2>/dev/null | grep .*: | sed -e 's/:$/\//g' | sort | uniq
  ); do
    DATABASE_NAME=${DATABASES[$(echo ${DATABASE_PATH} | grep -Eo "world|character|auth")]}
    echo -e "\tFor current database: ${INF}${DATABASE_NAME}${END}"
    for SQL in $(find ${DATABASE_PATH} -type f -name '*.sql'); do
      if (( AUTO==1 ))
      then
        mysql -u${USER} -h${HOST} -D${DATABASE_NAME} -p${PSWD} < ${SQL};
      else
        while true; do
          read -p "$(echo -e "\t\tApply from module ${INF}\"${MODULE_NAME}\"${END} to database ${INF}\"${DATABASE_NAME}\"${END} sql update ${INF}\"$(echo ${SQL} | sed -e 's/\([^\/]*\/\)*//g')\"${END}? ${INF}Y${END}/${INF}n${END}")"$'\n' yn
          case $yn in
              [Yy]* ) cp ${SQL} ../data/sql/custom/${DATABASE_NAME}; break;;
              [Nn]* ) break;;
              * ) echo -e "Please answer ${INF}y${END}es or ${INF}n${END}o.";;
          esac;
        done;
      fi;
    done;
  done;
done;
