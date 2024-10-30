#!/bin/sh
set -e

if [ -z "$1" ]; then
  echo "Error: No argument provided. Please provide a hostname."
  exit 1
fi

cat << EOF >> post-build.sh

# Modify system hostname
sed -i 's/buildroot/$1/' \${TARGET_DIR}/etc/hostname
sed -i 's/buildroot/$1/' \${TARGET_DIR}/etc/hosts
EOF
