#/usr/bin/sh

ERR="\e[32m"
INF="\e[36m"
END="\e[0m"

help()
{
   echo ""
   echo -e "${INF}Usage: $0 -p [conf file path]${END}"
   exit 1 # Exit script after printing help
}

while getopts "p:" opt
do
   case "$opt" in
      p ) CONF_PATH="$OPTARG" ;;
      ? ) helpFunction ;; # Print helpFunction in case parameter is non-existent
   esac
done

if ${#CONF_PATH} == 0
then
   echo -e "${ERR}Entry a valid path${END}";
   help
fi

cd ..
echo "Search for conf files in modules:"
for MODULE_NAME in $(
  ls $(find mod-*/ -type f -name '*conf.dist') 2>/dev/null | grep -Eo ".*/" | sed -e 's/\/.*//g' | sort | uniq
); do
  echo -e "Current module: ${INF}${MODULE_NAME}${END}"
  for MOD_PATH in $(
    find ${MODULE_NAME}/ -type f -name '*.conf.dist'
  ); do
    CONF_NAME=$(echo ${MOD_PATH} | grep -Eo "[^/]+\.conf\.dist" | grep -Eo ".*\.conf")
    while true; do
      read -p "$(echo -e "\tCopy from module ${INF}\"${MODULE_NAME}\"${END} conf file ${INF}\"${CONF_NAME}\"${END}? ${INF}Y${END}/${INF}n${END}")"$'\n' yn
      case $yn in
        [Yy]* ) cp ${MOD_PATH} ${CONF_PATH}${CONF_NAME}; break;;
        [Nn]* ) break;;
        * ) echo -e "Please answer ${INF}y${END}es or ${INF}n${END}o.";;
      esac;
    done;
  done;
done;

