#!/bin/bash

SHA_SUM="17ee607fa829f67b8b920438ebca5ec1deab3276"
RELEASE_FILE="bs-platform-2.0.0.tgz"
BS_PLATFORM_URL="https://registry.npmjs.org/bs-platform/-/${RELEASE_FILE}"

wget "$BS_PLATFORM_URL"
SHA_SUM_CHECKED=`shasum $RELEASE_FILE`

if [ "$SHA_SUM_CHECKED" != "$SHA_SUM  $RELEASE_FILE" ]; then
  echo "ERROR!!!"
  echo "The shasum didn't check out: Expecting: $SHA_SUM  $RELEASE_FILE but found: $SHA_SUM_CHECKED"
  echo "ERROR!!!"
  exit 1
fi

# Extracts here, there will be a package/
tar -xvf "$RELEASE_FILE"
# These flags work on mac - not tested on linux.
sed -i '.bak' 's/bs-platform/@esy-ocaml\/bs-platform/g' package/package.json
mv ./package/* .
rm -rf ./package/
rm -rf "$RELEASE_FILE"

echo ""
echo "Now, run npm publish"
