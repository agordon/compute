#!/bin/sh

##
## A small helper script to build an RPM pacakge
##

die()
{
  BASE=$(basename "$0")
  echo "$BASE error: $@" >&2
  exit 1
}

cd $(dirname "$0")/.. || die "failed to set directory"
PROJECT_DIR=$(pwd) || die "failed to get project's directory"

## Build version (e.g. "1.0.3.2-abcd")
BUILDVER=$(./build-aux/git-version-gen .tarball-version)
[ -z "$BUILDVER" ] && die "failed to detect latest build version"

CLEANTAG=$(echo "$BUILDVER" | grep -E '^[0-9]+\.[0-9]+\.[0-9]+' | sed -r 's/^([0-9]+\.[0-9]+\.[0-9]+\.[0-9]+).*/\1/')

echo "$BUILDVER" | grep -q -- "-" &&
	die "Error: packaged versions must not contain git chageset version (current version: '$BUILDVER').    To build RPM pacakge, add a temporary tag (e.g. 'git tag -m \"\" -a v$CLEANTAG'), and remove it after build"


## The distribution file should already exist
PROJECT=compute
TARBALL=${PROJECT}-${BUILDVER}.tar.gz
[ -e "$TARBALL" ] || die "Source tarball not found '$TARBALL' - did you run 'make dist'?"

## Detect architecture/distribution (ugly hack)
ARCH=$(rpm --eval "%{_arch}") || die "failed to detect build architecture (e.g. x86_64/i686)"
DIST=$(rpm --eval "%{dist}") || die "failed to detect build distribution (e.g. el5/el6)"
DIST=${DIST#.} # Remove prefix dot, if any


##
## Build the 'rpmbuild' tree
##
DIR=$(mktemp -d rpmbuild.XXXXX) || die "failed to create temporary rpm build directory"
mkdir -p "$DIR/SOURCES" "$DIR/BUILD" \
          "$DIR/BUILDROOT" "$DIR/RPMS" "$DIR/SRPMS" "$DIR/SPECS" || exit 1
cp rpm/compute.spec "$DIR/SPECS" || exit 1
cp "$TARBALL" "$DIR/SOURCES" || exit 1

##
## Build the RPM
##
rpmbuild --define="_topdir $PROJECT_DIR/$DIR" -ba $DIR/SPECS/compute.spec || die "rpmbuild failed"

## This should be the resulting DEB file
RPMVER=1
RPMFILE=${PROJECT}-${BUILDVER}-${RPMVER}.${DIST}.${ARCH}.rpm
RPMFULLPATH=$DIR/RPMS/$ARCH/$RPMFILE

[ -e "$RPMFULLPATH" ] || die "Failed to find expected RPM package file '$RPMFULLPATH' after rpmbuild"
cp "$RPMFULLPATH" "$PROJECT_DIR" || die "Failed to copy '$RPMFULLPATH' to project's directory"

echo
echo "Done!"
echo "RPM package:"
echo "  $RPMFILE"
echo ""
echo "To inspect its content, run:   rpm -qpl $RPMFILE"
echo ""
