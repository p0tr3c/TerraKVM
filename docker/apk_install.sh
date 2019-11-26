#!/bin/bash
APK_REQUIREMENTS="/tmp/apk_requirements.txt"

for i in `cat $APK_REQUIREMENTS`; do
    apk add $i;
done
