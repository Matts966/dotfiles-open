#!/usr/bin/env zsh
# This is a script to prevent nested vim.

readlink-f() {
    TARGET_FILE=$1
    while [ "$TARGET_FILE" != "" ]; do
        cd `dirname $TARGET_FILE`
        FILENAME=`basename $TARGET_FILE`
        TARGET_FILE=`readlink $FILENAME`
    done
    echo `pwd -P`/$FILENAME
}

if [[ ! -z "$VIM_TERMINAL" ]]; then
    if [ $# -eq 0 ]; then
        echo "You are already inside Vim. Provide filenames as arguments"
    else
        readlink-f $@ | xargs printf '\033]51;["call", "Tapi_vit", ["%s"]]\007'
    fi
else
    command vim $@
fi
