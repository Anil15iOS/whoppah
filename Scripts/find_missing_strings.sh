#!/bin/bash
RED='\033[0;31m'
NC='\033[0m' # No Color

SCRIPT_DIRECTORY=$(cd "$(dirname "$0")"; pwd)
PROJECT_DIR=${PROJECT_DIR:-$SCRIPT_DIRECTORY/..}
RESULTS=`grep -hor --include="*.storyboard" --include="*.xib" "l8nKey\" value=\".*\"" $PROJECT_DIR | awk -F' ' '{print $2}' | sed -E 's/value=\"(.*)\"/\1/'`

LANGUAGES=(
    en
    nl-NL
)
HAS_MISSING=0
for language in "${LANGUAGES[@]}"; do 
    LOCALIZATIONS=`cat "$PROJECT_DIR/Whoppah/Resources/Localization/$language.lproj/Localizable.strings"`
    for val in $RESULTS; do
        if [ ${#val} -ge 2 ]; then 
            if [[ ! "$LOCALIZATIONS" == *"$val"* ]]; then
                #echo "does not contain '$val'";
                echo "Missing text '$val' from $language.lproj/Localizable.strings"
                HAS_MISSING=1
            fi
        fi
    done
done

exit $HAS_MISSING