#!/bin/bash

SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
SCRIPTDIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
SOURCE="$(readlink "$SOURCE")"
[[ $SOURCE != /* ]] && SOURCE="$SCRIPTDIR/$SOURCE"
done
SCRIPTDIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

if [ -z "$1" ]; then
  echo "You must supply an upstream version like this:"
  echo "./createRelease.sh 2.0.0"
  exit 1
fi

UPSTREAM_VERSION="$1"
UPSTREAM_CHECKSUM_FILE="${SCRIPTDIR}/packageInfo/upstreamChecksums/${UPSTREAM_VERSION}.txt"
VERSION_MAPPING_FILE="${SCRIPTDIR}/packageInfo/esy-ocaml-versionMapping/${UPSTREAM_VERSION}.upstream.txt"

if [ -f "${UPSTREAM_CHECKSUM_FILE}" ]; then
  true
else
  echo "No checksum located at: ${UPSTREAM_CHECKSUM_FILE}"
  exit 1
fi

if [ -f "${VERSION_MAPPING_FILE}" ]; then
  true
else
  echo "No version mapping file located at: ${VERSION_MAPPING_FILE}"
  exit 1
fi

ESY_OCAML_VERSION=$(cat ${VERSION_MAPPING_FILE})
SHA_SUM=$(cat "${UPSTREAM_CHECKSUM_FILE}")
RELEASE_FILE="bs-platform-${UPSTREAM_VERSION}.tgz"
BS_PLATFORM_URL="https://registry.npmjs.org/bs-platform/-/${RELEASE_FILE}"

wget "$BS_PLATFORM_URL"
SHA_SUM_CHECKED=$(shasum $RELEASE_FILE)

if [ "$SHA_SUM_CHECKED" != "${SHA_SUM}  ${RELEASE_FILE}" ]; then
  echo "ERROR!!!"
  echo "The shasum didn't check out: Expecting: $SHA_SUM  $RELEASE_FILE but found: $SHA_SUM_CHECKED"
  echo "ERROR!!!"
  exit 1
fi

# Extracts here, there will be a package/
tar -xvf "$RELEASE_FILE"
# These flags work on mac - not tested on linux.

# We include both an esy.json and a package.json, and esy will only pay
# attention to the esy.json. We just needed to make sure package.json had the
# right version/name because that's the only thing npm pays attention to.
sed -i '.bak' "s/_VERSION_/${ESY_OCAML_VERSION}/g" esy.json
sed -i '.bak' 's/bs-platform/@esy-ocaml\/bs-platform/g' package/package.json
sed -i '.bak' "s/\"version\": \"${UPSTREAM_VERSION}\"/\"version\": \"${ESY_OCAML_VERSION}\"/g" package/package.json

if [ "${VERSION}" == "2.0.0" ]; then
  mv package/jscomp/bin/bsb.ml package/jscomp/bin/bsb.ml.orig
  patch ./package/jscomp/bin/bsb.ml.orig -i "./packageInfo/upstreamPatches/${UPSTREAM_VERSION}/jscomp/bin/bsb.ml.patch" -o ./package/jscomp/bin/bsb.ml
fi

if [ "${VERSION}" == "2.1.0" ]; then
  rm -f ./package/lib/*.darwin
  rm -f ./package/lib/*.linux64
  rm -f ./package/lib/*.win
  mv ./package/lib/bsb.ml ./package/lib/bsb.ml.orig
  patch ./package/lib/bsb.ml.orig -i "./packageInfo/upstreamPatches/${UPSTREAM_VERSION}/lib/bsb.ml.patch" -o ./package/lib/bsb.ml
fi

# Remove the heavy docs and site directories
rm -rf package/site/
rm -rf package/docs/
rm -rf package/vendor/ocaml/
rm -rf package/jscomp/bin/*.win

# Now we patch bsb.

cp esy.json ./package

# Restore the original esy.json
cp esy.json.bak ./esy.json
rm -rf "$RELEASE_FILE"

echo ""
echo "Now, run:"
echo ""
echo "  cd package"
echo "  npm publish"
echo ""
