#!/bin/sh
set -e

if [ -z "$1" ]; then
  echo "Error: No argument provided. Please provide a font size."
  exit 1
elif [ "$1" = "small (50 cols x 30 rows)" ]; then
  :
  # No changes needed, this is the default font size in cmdline.txt
elif [ "$1" = "larger (50 cols x 15 rows)" ]; then
  sed -i 's/VGA8x8/VGA8x16/' cmdline.txt
else
  echo "Error: '$1' is an unrecognized font size."
  exit 1
fi
