#!/bin/sh

##
## A small helper script to build a debian pacakge
##

die()
{
  BASE=$(basename "$0")
  echo "$BASE error: $@" >&2
  exit 1
}

cd $(dirname "$0")/.. || die "failed to set directory"

## Build version (e.g. "1.0.3.2-abcd")
BUILDVER=$(./build-aux/git-version-gen .version)
[ -z "$BUILDVER" ] && die "failed to detect latest build version"

## Release version (e.g. "1.0.3")
## NOTE: this is an ugly hack - as it could lead to duplicated release versions...
RELVER=$(echo "$BUILDVER" |  grep -E '^[0-9]+\.[0-9]+\.[0-9]+' | sed -r 's/^([0-9]+\.[0-9]+\.[0-9]+).*/\1/')
[ -z "$RELVER" ] && die "failed to detect release version based on build version '$BUILDVER'"

## The distribution file should already exist
PROJECT=compute
TARBALL=${PROJECT}-${BUILDVER}.tar.gz
[ -e "$TARBALL" ] || die "Source tarball not found '$TARBALL' - did you run 'make dist'?"

## Find the Debian platform values (e.g. architecture = amd64)
eval `dpkg-architecture` || die "failed to run 'dpkg-architecture' - is 'dpkg-dev' installed?"

DIR=$(mktemp -d debbuild.XXXXXXX) || die "failed to create temporary build directory"

cp "$TARBALL"  "${DIR}/${PROJECT}_${RELVER}.orig.tar.gz" || die "failed to copy tarball"
cd "$DIR" || exit 1
tar -xzf "${PROJECT}_${RELVER}.orig.tar.gz" || die "failed to extract source tarball"

## Ugly Hack NOTE:
## The tarball must be named with ".orig" for the debian build system,
## but the directory name will contain the full build version (e.g. "10.0.2-abcd")
cd "${PROJECT}-${BUILDVER}" || die "failed to CD into build directory"
debuild -uc -us || die "Failed to build debian package, check directory '$DIR/${PROJECT}-${BUILDVER}'"
cd .. || exit 1

## Debian packaging-version
## MUST match the one inside 'debian/changelog'
## TODO: generate it automatically?
DEBVER=1

## This should be the resulting DEB file
DEBFILE=${PROJECT}_${RELVER}-${DEBVER}_${DEB_BUILD_ARCH}.deb
[ -e "$DEBFILE" ] || die "Failed to find expected debian package file '$DIR/$DEBFILE' after debuild"
cp "$DEBFILE" .. || die "Failed to copy '$DEBFILE' to project's directory"
cd .. || exit 1
rm -r --interactive=never "./$DIR" || die "failed to cleanup temp build directory '$DIR'"

echo
echo "Done!"
echo "Debian package:"
echo "  $DEBFILE"
echo ""
echo "To inspect its content, run:   dpkg-deb -c $DEBFILE"
echo ""
