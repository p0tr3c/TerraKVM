#!/bin/bash

function execute_test(){
    /bin/bash "${1}.sh"
    if [ "$?" -ne "0" ]; then
        echo "FAIL: $1"
        cat "${1}.log"
        return -1
    fi
    echo "PASS: $1"
    return 0
}

declare -a aws_tests=(
    "test_distro_sources",
    "test_distro_sources_signatures")

for aws_test in "${aws_tests[@]}"
do
    res=execute_test "$aws_test"
    if [ $res -ne 0 ]; then
        exit 1
    fi
done
