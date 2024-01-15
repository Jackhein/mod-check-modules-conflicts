#/usr/bin/sh

#Color code
ERR="\e[31m"
INF="\e[36m"
END="\e[0m"

#Path and folders where to copy sql files
CUSTOM_PATH="data/sql/custom/"
declare -A DATABASES
DATABASES["auth"]="db_auth"
DATABASES["character"]="db_characters"
DATABASES["world"]="db_world"

#Ignore following modules as their path are already checked (see list under apps/ci/ci-install-modules.sh)
IGNORE_CASE="(mod-eluna|mod-autobalance|mod-ah-bot|mod-anticheat|mod-bg-item-reward|mod-cfbg|mod-chat-transmitter|mod-cta-switch|mod-desertion-warnings|mod-duel-reset|mod-ip-tracker|mod-low-level-arena|mod-low-level-rbg|mod-multi-client-check|mod-pvp-titles|mod-pvpstats-announcer|mod-queue-list-cache|mod-server-auto-shutdown|mod-transmog|mod-progression-system)"

#Automatic applyance
AUTO=0

help()
{
  echo ""
  echo -e "${INF}Usage: $0 -h (show help) |-y (for automatic use)${END}"
  exit 1 # Exit script after printing help
}

while getopts "h:u:p:a:c:w:y" opt
do
  case "$opt" in
    y ) AUTO=1 ;;
    ? ) help ;; # Print helpFunction in case parameter is non-existent
  esac
done

cd ..
echo "Search for sql updates in modules:"
for MODULE_NAME in $(
  ls $(find mod-*/ -type f -name '*.sql') 2>/dev/null | grep -Eo ".*/" | sed -e 's/\/.*//g' | sort | uniq | grep -vE ${IGNORE_CASE}
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
        echo -e "\t\tApply from module ${INF}\"${MODULE_NAME}\"${END} to database ${INF}\"${DATABASE_NAME}\"${END} sql update ${INF}\"$(echo ${SQL} | sed -e 's/\([^\/]*\/\)*//g')\"${END}"
        cp ${SQL} ../${CUSTOM_PATH}${DATABASE_NAME};
      else
        while true; do
          read -p "$(echo -e "\t\tApply from module ${INF}\"${MODULE_NAME}\"${END} to database ${INF}\"${DATABASE_NAME}\"${END} sql update ${INF}\"$(echo ${SQL} | sed -e 's/\([^\/]*\/\)*//g')\"${END}? ${INF}Y${END}/${INF}n${END}")"$'\n' yn
          case $yn in
              [Yy]* ) cp ${SQL} ../${CUSTOM_PATH}${DATABASE_NAME}; break;;
              [Nn]* ) break;;
              * ) echo -e "Please answer ${INF}y${END}es or ${INF}n${END}o.";;
          esac;
        done;
      fi;
    done;
  done;
done;
