#/usr/bin/sh

ERR="\e[31m"
INF="\e[36m"
END="\e[0m"

help()
{
   echo ""
   echo -e "${INF}Usage: $0 -p [dbc files path]${END}"
   exit 1 # Exit script after printing help
}

while getopts "p:" opt
do
   case "$opt" in
      p ) DBC_PATH="$OPTARG" ;;
      ? ) help ;; # Print helpFunction in case parameter is non-existent
   esac
done

if (( ${#DBC_PATH} == 0 ))
then
   echo -e "${ERR}Some or all of the parameters are empty${END}";
   help
fi

cd ..
echo "Search dbc files in modules:"
for MODULE_NAME in $(
  ls $(find mod-*/ -type f -name '*.dbc') 2>/dev/null | grep -Eo ".*/" | sed -e 's/\/.*//g' | sort | uniq
); do
  echo -e "Current module: ${INF}${MODULE_NAME}${END}"
  for MOD_PATH in $(
    find ${MODULE_NAME}/ -type f -name '*.dbc'
  ); do
    DBC_NAME=$(echo ${MOD_PATH} | grep -Eo "[^/]+\.dbc")
    while true; do
      read -p "$(echo -e "\tCopy from module ${INF}\"${MODULE_NAME}\"${END} dbc file ${INF}\"${DBC_NAME}\"${END}? ${INF}Y${END}/${INF}n${END}")"$'\n' yn
      case $yn in
        [Yy]* ) cp ${MOD_PATH} ${DBC_PATH}${DBC_NAME}; break;;
        [Nn]* ) break;;
        * ) echo -e "Please answer ${INF}y${END}es or ${INF}n${END}o.";;
      esac;
    done;
  done;
done;
