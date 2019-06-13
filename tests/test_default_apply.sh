#!/bin/bash
PROJECT_DIR=`realpath "$PWD/../"`
TEST_DIR=`realpath $PWD`

TEST_NAME="`basename $0`"
TEST_NAME="${TEST_NAME%.*}"

cd "${PROJECT_DIR}" && \
    sudo ./terrakvm apply >> "${TEST_DIR}/${TEST_NAME}.log" 2>&1

if [ "$?" -eq "0" ]; then
    echo "PASS: ${TEST_NAME}:execute:apply"
else
    echo "FAIL: ${TEST_NAME}:execute:apply"
    exit 1
fi

cd "${PROJECT_DIR}" && \
    sudo docker-compose --log-level ERROR up >> "${TEST_DIR}/${TEST_NAME}.log" 2>&1  &
RETRY_COUNT=10
while :
do
    res=`sudo docker ps -f name=terrakvm -q`
    if [ ! -z "$res" ]; then
        break
    fi
    ((RETRY_COUNT--))
    if [ $RETRY_COUNT -eq 0 ]; then
        echo "FAIL: ${TEST_NAME}:debug:up"
        exit 1
    fi
    sleep 1
done
echo "PASS: ${TEST_NAME}:debug:up"


cd "${PROJECT_DIR}" && \
    sudo docker exec terrakvm virsh --connect qemu:///system dumpxml dev >> "${TEST_DIR}/${TEST_NAME}.log" 2>&1
if [ "$?" -eq "0" ]; then
    echo "PASS: ${TEST_NAME}:unit:domain:applied"
else
    echo "FAIL: ${TEST_NAME}:unit:domain:applied"
    exit 1
fi

cd "${PROJECT_DIR}" && \
    sudo docker-compose --log-level ERROR down >> "${TEST_DIR}/${TEST_NAME}.log"  2>&1 &
RETRY_COUNT=10
while :
do
    res=`sudo docker ps -f name=terrakvm -q`
    if [ -z "$res" ]; then
       break
    fi
    ((RETRY_COUNT--))
    if [ $RETRY_COUNT -eq 0 ]; then
        echo "FAIL: ${TEST_NAME}:debug:down"
        exit 1
    fi
    sleep 1
done
echo "PASS: ${TEST_NAME}:debug:down"



cd "${PROJECT_DIR}" && \
    sudo ./terrakvm destroy >> "${TEST_DIR}/${TEST_NAME}.log" 2>&1

if [ "$?" -eq "0" ]; then
    echo "PASS: ${TEST_NAME}:execute:destroy"
else
    echo "FAIL: ${TEST_NAME}:execute:destroy"
fi


cd "${PROJECT_DIR}" && \
    sudo docker-compose --log-level ERROR up >> "${TEST_DIR}/${TEST_NAME}.log" 2>&1  &
RETRY_COUNT=10
while :
do
    res=`sudo docker ps -f name=terrakvm -q`
    if [ ! -z "$res" ]; then
        break
    fi
    ((RETRY_COUNT--))
    if [ $RETRY_COUNT -eq 0 ]; then
        echo "FAIL: ${TEST_NAME}:debug:up"
        exit 1
    fi
    sleep 1
done
echo "PASS: ${TEST_NAME}:debug:up"

cd "${PROJECT_DIR}" && \
    sudo docker exec terrakvm virsh --connect qemu:///system dumpxml dev >> "${TEST_DIR}/${TEST_NAME}.log" 2>&1
if [ "$?" -ne "0" ]; then
    echo "PASS: ${TEST_NAME}:unit:domain:destroyed"
else
    echo "FAIL: ${TEST_NAME}:unit:domain:destroyed"
    exit 1
fi

cd "${PROJECT_DIR}" && \
    sudo docker-compose --log-level ERROR down >> "${TEST_DIR}/${TEST_NAME}.log"  2>&1 &
RETRY_COUNT=10
while :
do
    res=`sudo docker ps -f name=terrakvm -q`
    if [ -z "$res" ]; then
       break
    fi
    ((RETRY_COUNT--))
    if [ $RETRY_COUNT -eq 0 ]; then
        echo "FAIL: ${TEST_NAME}:debug:down"
        exit 1
    fi
    sleep 1
done
echo "PASS: ${TEST_NAME}:debug:down"


