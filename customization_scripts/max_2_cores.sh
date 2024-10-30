#!/bin/sh
set -e

if [ "$1" = "true" ]; then
  # Restrict CPU to 2 cores to limit peak power use
  sed -i 's/console=tty1/console=tty1 maxcpus=2/' cmdline.txt
fi
