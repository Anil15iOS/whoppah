#!/bin/bash

if test -z "$CI"; then
    echo "Not running on CI - performing codegen"
else
    # No codegen on CI
    echo "Bypassing codegen on CI ${CI}"
    exit 0
fi

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

SRCROOT="${SRCROOT:-${SCRIPT_DIR}}"
PODS_ROOT="${PODS_ROOT:-${SRCROOT}/../../Pods}"

echo "${PODS_ROOT}"
SCRIPT_PATH="${PODS_ROOT}/Apollo/scripts"
GRAPHQL_PROJECT="${SRCROOT}/../../graphql-mobile"

# Replace with http://127.0.0.1 if developing locally
SERVER_URL=https://gateway.testing.whoppah.com
#SERVER_URL=http://127.0.0.1:3000

if [ ! -d "$GRAPHQL_PROJECT" ]; then
    echo "Missing directory: $GRAPHQL_PROJECT"
    exit 1
fi

cd "${GRAPHQL_PROJECT}"

npx apollo codegen:generate --passthroughCustomScalars --namespace="GraphQL" --mergeInFieldsFromFragmentSpreads --queries='./queries/*,./mutations/*' --endpoint=$SERVER_URL --target=swift "${SRCROOT}/WhoppahCore/Generated/"
RESULT=$?
if [ "$RESULT" == "0" ]; then
    echo "Codegen successful"
else
    echo "Codegen failed. Check your server is running"
    exit $RESULT
fi
