#/usr/bin/sh

ERR="\e[31m"
INF="\e[36m"
END="\e[0m"

help()
{
   echo ""
   echo -e "${INF}Usage: $0 -h [database address] -u [user] -p [password] -a [auth database] -c [character database] -w [world database] (-y for automatic use)${END}"
   exit 1 # Exit script after printing help
}

AUTO=0
declare -A DATABASES
while getopts "h:u:p:a:c:w:y" opt
do
   case "$opt" in
      h ) HOST="$OPTARG" ;;
      u ) USER="$OPTARG" ;;
      p ) PSWD="$OPTARG" ;;
      a ) DATABASES["auth"]="$OPTARG" ;;
      c ) DATABASES["character"]="$OPTARG" ;;
      w ) DATABASES["world"]="$OPTARG" ;;
      y ) AUTO=1 ;;
      ? ) helpFunction ;; # Print helpFunction in case parameter is non-existent
   esac
done

if (( ${#HOST} == 0 || ${#USER} == 0 || ${#PSWD} == 0 || (${#DATABASES["auth"]} == 0 && ${#DATABASES["character"]} == 0 && ${#DATABASES["world"]} == 0) ))
then
   echo -e "${ERR}Some or all of the parameters are empty${END}";
   help
fi

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
              [Yy]* ) mysql -u${USER} -h${HOST} -D${DATABASE_NAME} -p${PSWD} --default-character-set utf8mb4 < ${SQL}; break;;
              [Nn]* ) break;;
              * ) echo -e "Please answer ${INF}y${END}es or ${INF}n${END}o.";;
          esac;
        done;
      fi;
    done;
  done;
done;
