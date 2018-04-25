#!/bin/bash
NAME="TA-postfix"
REF="${1:-HEAD}"
VER=$(git describe --tags "$REF")

[[ -z $VER ]] && { echo "Can't describe ref $REF"; exit 1; }

ARCHIVE=${NAME}-${VER}.tgz

echo "Building $ARCHIVE @ $REF"

echo "Sanity checks  (for HUMAN review)"

echo "default/app.conf shows: "
git show "$REF":default/app.conf | grep -E '(version|build)'
echo

# Version not noted in README
#echo "README.md shows:"
#git show "$REF":README.md | grep -A3 "Change log"
#echo

git archive --format=tar.gz --prefix "${NAME}/" -o "$ARCHIVE" "$REF" || exit 1

echo "Sucessfully created $ARCHIVE"

echo "$ARCHIVE" > latest_release
