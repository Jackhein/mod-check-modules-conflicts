#/usr/bin/sh

cd ..
echo "Search for git patch in modules:"
for MODULE_NAME in $(ls mod-*/patch/*.patch | sed -e 's/\(\/[^\/]*\)*//g' | sort | uniq); do
  echo ${MODULE_NAME}
  for PATCH_NAME in $(ls ${MODULE_NAME}/patch/*.patch | sed -e 's/\([^\/]\|\\\/\)*\/\|.json$\|.csv$//g'); do
    while true; do
      read -p "     Apply patch ${PATCH_NAME} found in ${MODULE_NAME}? Y/n"$'\n' yn
      case $yn in
        [Yy]* ) git apply --ignore-space-change --ignore-whitespace modules/${MODULE_NAME}/${PATCH_NAME}.patch; break;;
        [Nn]* ) break;;
        * ) echo "Please answer yes or no.";;
      esac;
    done;
  done;
done;