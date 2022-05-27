#!/bin/sh

if [ "$#" -ne 2 ]; then
    echo "1) Build type: Testing/Production/Staging"
    echo "2) Path to dSYM file"
fi

SCRIPT_DIR="$(dirname "$0")"

./upload-symbols -gsp ${SCRIPT_DIR}/../Whoppah/Resources/Config/$1/GoogleService-Info.plist -p ios $2
