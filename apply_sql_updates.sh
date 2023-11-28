#/usr/bin/sh

help()
{
   echo ""
   echo "Usage: $0 -h [database address] -u [user] -p [password] -a [auth database] -c [character database] -w [world database]"
   exit 1 # Exit script after printing help
}

declare -A DATABASES
while getopts "h:u:p:a:c:w:" opt
do
   case "$opt" in
      h ) HOST="$OPTARG" ;;
      u ) USER="$OPTARG" ;;
      p ) PSWD="$OPTARG" ;;
      a ) DATABASES["auth"]="$OPTARG" ;;
      c ) DATABASES["character"]="$OPTARG" ;;
      w ) DATABASES["world"]="$OPTARG" ;;
      ? ) helpFunction ;; # Print helpFunction in case parameter is non-existent
   esac
done

if (( ${#HOST} == 0 || ${#USER} == 0 || ${#PSWD} == 0 || (${#DATABASES["auth"]} == 0 && ${#DATABASES["character"]} == 0 && ${#DATABASES["world"]} == 0) ))
then
   echo "Some or all of the parameters are empty";
   help
fi

cd ..
echo "Search for sql updates in modules:"
for MODULE_NAME in $(
  ls mod-*/sql/{auth,character,world} 2>/dev/null | grep .*: | sed -e 's/\(\/[^\/]*\)*//g' | sort | uniq
); do
  echo ${MODULE_NAME}
  for DATABASE_PATH in $(
    ls ${MODULE_NAME}/sql/{auth,character,world} 2>/dev/null | grep .*: | sed -e 's/:$/\//g' | sort | uniq
  ); do
    DATABASE_NAME=${DATABASE_PATH} | grep -Eo "auth|world|character"
    echo ${DATABASE_NAME}
    for SQL in $(find ${DATABASE_PATH}/ -type f -name '*.sql'); do
      while true; do
	      read -p "     Apply sql update from module \"${MODULE_NAME}\" to database \"${DATABASES[$(echo ${DATABASE_PATH} | grep -Eo "world|character|auth")]}\": \"$(echo ${SQL} | sed -e 's/\([^\/]*\/\)*//g')\"? Y/n"$'\n' yn
        case $yn in
          [Yy]* ) mysql -u${USER} -h${HOST} -D${DATABASES[${DATABASE_PATH}]} -p${PSWD} < ${SQL}; break;;
          [Nn]* ) break;;
          * ) echo "Please answer yes or no.";;
        esac;
      done;
    done;
  done;
done;
