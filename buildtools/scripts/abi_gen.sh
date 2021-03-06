#!/bin/sh
# generate a set of ABI signatures from a shared library

SHAREDLIB="$1"

GDBSCRIPT="gdb_syms.$$"

(
cat <<EOF
set height 0
set width 0
EOF
nm "$SHAREDLIB" | cut -d' ' -f2- | egrep '^[BDGTRVWS]' | grep -v @ | egrep -v ' (__bss_start|_edata|_init|_fini|_end)' | cut -c3- | sort | while read s; do
    echo "echo $s: "
    echo p $s
done
) > $GDBSCRIPT

# forcing the terminal avoids a problem on Fedora12
TERM=none gdb -n -batch -x $GDBSCRIPT "$SHAREDLIB" < /dev/null
rm -f $GDBSCRIPT
