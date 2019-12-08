#!/bin/bash
set -e

## This script will compile Gluon for all architectures, create the
## manifest and sign it. For that, you must have clone gluon and have a
## valid site config. Additionally, the signing key must be present in
## ../../ecdsa-key-secret or defined as first argument.
## The second argument defines the branch (stable, beta, experimental).
## The third argument defines the version.
## Call from site directory with the version and branch variables
## properly configured in this script.

SIGNING_KEY=$(readlink -e "$1")
JOBS=$(nproc --all)

function run_and_print() {
    echo -e "\n\n\n$@"
    "$@"
}

cd ..
if [ ! -d "site" ]; then
	echo "This script must be called from within the site directory"
	exit 1
fi
. site/ansi-colors.sh # utilities

rm -rf output
# one-time preparation
run_and_print make update
. site/banner.sh # install our banner
cat openwrt/package/base-files/files/etc/banner
echo
# loop for a
for TARGET in \
	ar71xx-generic ar71xx-tiny ar71xx-nand \
	brcm2708-bcm2708 brcm2708-bcm2709 \
	mpc85xx-generic mpc85xx-p1020 \
	ramips-mt7620 ramips-mt7621 ramips-mt76x8 ramips-rt305x \
	sunxi-cortexa7 \
	ipq40xx \
	x86-generic x86-geode x86-64
do
	echo_color "$BOLDGREEN" "Starting work on target $TARGET"
	df -h
	# GLUON_BRANCH configures the default autoupdater branch.
	run_and_print make GLUON_TARGET="$TARGET" GLUON_BRANCH="$RELEASE_BRANCH" GLUON_RELEASE="$RELEASE_VERSION" -j$JOBS
        # We clean to avoid running out of disk space.
	run_and_print make GLUON_TARGET="$TARGET" clean -j$JOBS
	echo -e "\n\n\n============================================================\n\n"
done

echo_color "$BOLDGREEN" "Compilation complete, creating and signing manifest(s)"

run_and_print make GLUON_BRANCH=experimental GLUON_PRIORITY=1 GLUON_RELEASE=$RELEASE_VERSION manifest
run_and_print contrib/sign.sh $SIGNING_KEY output/images/sysupgrade/experimental.manifest
echo -e "\n\n\n============================================================\n\n"

if [[ "$RELEASE_BRANCH" == "beta" ]] || [[ "$RELEASE_BRANCH" == "stable" ]]
then
	run_and_print make GLUON_BRANCH=beta GLUON_PRIORITY=2 GLUON_RELEASE=$RELEASE_VERSION manifest
	run_and_print contrib/sign.sh $SIGNING_KEY output/images/sysupgrade/beta.manifest
	echo -e "\n\n\n============================================================\n\n"
fi

if [[ "$RELEASE_BRANCH" == "stable" ]]
then
	run_and_print make GLUON_BRANCH=stable GLUON_PRIORITY=7 GLUON_RELEASE=$RELEASE_VERSION manifest
	run_and_print contrib/sign.sh $SIGNING_KEY output/images/sysupgrade/stable.manifest
	echo -e "\n\n\n============================================================\n\n"
fi

cd site
echo_color "$BOLDGREEN" "Done :)"
