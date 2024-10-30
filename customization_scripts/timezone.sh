#!/bin/sh
set -e

# Note that time zones in the Buildroot OS config must be specified in POSIX
# format (e.g. EST5EDT) rather than the more common IANA format
# (e.g. America/New_York).
# 
# Documentation: https://developer.ibm.com/articles/au-aix-posix/
#
# Douglas Adams might have said that "this has made a lot of people very angry
# and been widely regarded as a bad move" but the POSIX time zone is being used
# in various places within the Buildroot OS config, so I haven't tried to
# refactor the code to use the IANA time zone format.
#
# This script simply translates a handful of common time zones to their POSIX
# equivalents.
#
# I apologize if your time zone isn't included in this list, there are simply
# too many time zones. You can manually add your time zone here or enter it
# directly in timezone.txt in POSIX format.

if [ -z "$1" ]; then
  echo "Error: No argument provided. Please provide a time zone."
  exit 1
elif [ "$1" = "Hawaii" ]; then
  sed -i 's/UTC0/HST11HDT/' timezone.txt
elif [ "$1" = "Alaska" ]; then
  sed -i 's/UTC0/ASKT9AKDT/' timezone.txt
elif [ "$1" = "Pacific Time (US and Canada)" ]; then
  sed -i 's/UTC0/PST8PDT/' timezone.txt
elif [ "$1" = "Mountain Time (US and Canada)" ]; then
  sed -i 's/UTC0/MST7MDT/' timezone.txt
elif [ "$1" = "Central Time (US and Canada)" ]; then
  sed -i 's/UTC0/CST6CDT/' timezone.txt
elif [ "$1" = "Eastern Time (US and Canada)" ]; then
  sed -i 's/UTC0/EST5EDT/' timezone.txt
elif [ "$1" = "Atlantic Time (Canada)" ]; then
  sed -i 's/UTC0/AST4ADT/' timezone.txt
elif [ "$1" = "Newfoundland (Canada)" ]; then
  sed -i 's/UTC0/NST3:30NDT/' timezone.txt
elif [ "$1" = "UTC" ]; then
  :
  # default time zone is already UTC
elif [ "$1" = "Western European Time" ]; then
  sed -i 's/UTC0/WET0WEST/' timezone.txt
elif [ "$1" = "Central European Time" ]; then
  sed -i 's/UTC0/CET-1CEST/' timezone.txt
elif [ "$1" = "Eastern European Time" ]; then
  sed -i 's/UTC0/EET-2EEST/' timezone.txt
elif [ "$1" = "Israel" ]; then
  sed -i 's/UTC0/IST-2IDT/' timezone.txt
elif [ "$1" = "Moscow Time" ]; then
  sed -i 's/UTC0/MSK-3/' timezone.txt
elif [ "$1" = "India" ]; then
  sed -i 's/UTC0/IST-5:30/' timezone.txt
elif [ "$1" = "China" ]; then
  sed -i 's/UTC0/CST-8/' timezone.txt
elif [ "$1" = "Japan" ]; then
  sed -i 's/UTC0/JST-9/' timezone.txt
elif [ "$1" = "Korea" ]; then
  sed -i 's/UTC0/KST-9/' timezone.txt
elif [ "$1" = "New Zealand" ]; then
  sed -i 's/UTC0/NZST-12NZDT/' timezone.txt
else
  echo "Error: '$1' is an unrecognized time zone."
  echo "You could manually add it to 'customization_scripts/timezone.sh'"
  exit 1
fi
