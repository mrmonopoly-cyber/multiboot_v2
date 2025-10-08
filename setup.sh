!# /bin/bash

if [[ ! -d ./.git ]]; then
  echo "run the script from the root of the project"
  exit 1
fi

mkdir i686-elf
cd i686-elf

wget https://github.com/lordmilko/i686-elf-tools/releases/download/13.2.0/i686-elf-tools-linux.zip
unzip i686-elf-tools-linux.zip
