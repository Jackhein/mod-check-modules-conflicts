#/usr/bin/sh

cd ../..
echo "Search for git patch in modules:"
for MODULE_NAME in $(
  ls modules/mod-*/patch/*.patch 2>/dev/null | sed -e 's/\(modules\/\|\(\/[^\/]*\)*\)//g' | sort | uniq
); do
  echo ${MODULE_NAME}
  for PATCH_NAME in $(
      ls modules/${MODULE_NAME}/patch/*.patch 2>/dev/null | sed -e 's/\([^\/]\|\\\/\)*\/\|.patch\|.csv$//g'
  ); do
    while true; do
      read -p "     Apply patch ${PATCH_NAME} found in ${MODULE_NAME}? Y/n"$'\n' yn
      case $yn in
        [Yy]* )
          git apply --ignore-space-change --ignore-whitespace modules/${MODULE_NAME}/patch/${PATCH_NAME}.patch; break;;
        [Nn]* )
          break;;
        * )
          echo "Please answer yes or no.";;
      esac;
    done;
  done;
done;