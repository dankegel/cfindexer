#!/bin/sh
# List cached council files, most recent first.
# Prerequisite: grab-recent.sh ran at least once in current directory.

# Expand years 00-69 to 2000-2069, and 70-99 to 1970-1999.
expand_years() {
  sed '/^[0-6][0-9]-/s,^,20,;/^[7-9][0-9]-/s,^,19,'
}

unexpand_years() {
  sed '/^20[0-6][0-9]-/s,^20,,;/^19[7-9][0-9]-/s,^19,,'
}

# Avoid expanding wildcards on commandline, that fails above 10,000 files.
# Use 'find' rather than 'ls' to avoid double-sorting and make wildcards
# more readable.

find . -name '[0-9]*-*.html' -print |
  sed 's,^./,,' |
  expand_years |
  sort -r |
  unexpand_years
