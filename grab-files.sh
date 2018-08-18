#!/bin/sh
# For each council file number in the given file,
#   if it doesn't exist yet, or --force given,
#      fetch its page to $cfnum.html
set -ex

case "$1" in
""|"-h"|"--help") echo "Usage: $0 [--force] cfnums.txt"; exit 1;;
*) ;;
esac

do_file() {
   local cfnum
   for cfnum in $(cat "$1")
   do
      if $force || ! test -s "$cfnum.html"
      then
         curl --fail "https://cityclerk.lacity.org/lacityclerkconnect/index.cfm?fa=ccfi.viewrecord&cfnumber=$cfnum" > "$cfnum.html"
      fi
   done
}

force=false
for arg in "$@"
do
  case "$arg" in
  --force)
    force=true
    ;;
  *)
    do_file "$arg"
    ;;
  esac
done
