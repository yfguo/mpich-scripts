#!/bin/sh -e

function get_project_dir {
    if [[ -e "${1}/.git" ]]; then
        echo ${1}
    elif [[ "${1}" = "$HOME" ]]; then
        echo ${1}
    else
        get_project_dir $(realpath ${1}/../)
    fi
}

MAKE_ARGS=${@:1}
while getopts ":c:" opt; do
    case "$opt" in
        c)
            clean=yes
            MAKE_ARGS=${@:2}
            ;;
    esac
done

CURRENT_DIR=$PWD

PROJECT_DIR=$(get_project_dir ${PWD})

cd $PROJECT_DIR

if [[ ! -e "$PROJECT_DIR/compile_commands.json" ]]; then
    bear --make $MAKE_ARGS
else
    if [[ "$clean" == "yes" ]]; then
        rm $PROJECT_DIR/compile_commands.json
        bear -- make $MAKE_ARGS
    else
        make $MAKE_ARGS
    fi
fi

cd $CURRENT_DIR
