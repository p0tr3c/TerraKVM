#!/bin/bash

function execute_test(){
    /bin/bash "${1}.sh" > /dev/null
    if [ "$?" -ne "0" ]; then
        return -1
    fi
    return 0
}

declare -a aws_tests=(
    "test_distro_sources"
    "test_distro_sources_signatures")

for aws_test in "${aws_tests[@]}"
do
    execute_test $aws_test
    if [ "$?" -ne 0 ]; then
        echo "FAIL: $aws_test"
        cat "${aws_test}.log"
        exit 1
    fi
    echo "PASS: $aws_test"
done
