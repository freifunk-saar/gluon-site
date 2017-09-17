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

cd ..
if [ ! -d "site" ]; then
	echo "This script must be called from within the site directory"
	return
fi

rm -rf output
for TARGET in \
	ar71xx-generic ar71xx-nand ar71xx-tiny brcm2708-bcm2708 brcm2708-bcm2709 mpc85xx-generic x86-generic x86-geode x86-64
do
	echo "Starting work on target $TARGET"
	echo -e "\n\n\nmake GLUON_TARGET=$TARGET GLUON_BRANCH=stable GLUON_RELEASE=$VERSION update"
	make GLUON_TARGET=$TARGET GLUON_BRANCH=stable GLUON_RELEASE=$VERSION update
	echo -e "\n\n\nmake GLUON_TARGET=$TARGET GLUON_BRANCH=stable GLUON_RELEASE=$VERSION clean"
	make GLUON_TARGET=$TARGET GLUON_BRANCH=stable GLUON_RELEASE=$VERSION -j8 clean
	echo -e "\n\n\nmake GLUON_TARGET=$TARGET GLUON_BRANCH=stable GLUON_RELEASE=$VERSION -j8"
	make GLUON_TARGET=$TARGET GLUON_BRANCH=stable GLUON_RELEASE=$VERSION -j8
	echo -e "\n\n\n============================================================\n\n"
done
echo "Compilation complete, creating manifest(s)"

echo -e "make GLUON_BRANCH=experimental manifest"
make GLUON_BRANCH=experimental manifest
echo -e "\n\n\n============================================================\n\n"

if [[ "$BRANCH" == "beta" ]] || [[ "$BRANCH" == "stable" ]]
then
	echo -e "make GLUON_BRANCH=beta manifest"
	make GLUON_BRANCH=beta manifest
	echo -e "\n\n\n============================================================\n\n"
fi

if [[ "$BRANCH" == "stable" ]]
then
	echo -e "make GLUON_BRANCH=stable manifest"
	make GLUON_BRANCH=stable manifest
	echo -e "\n\n\n============================================================\n\n"
fi

echo "Manifest creation complete, signing manifest"

echo -e "contrib/sign.sh $SIGNING_KEY output/images/sysupgrade/experimental.manifest"
contrib/sign.sh $SIGNING_KEY output/images/sysupgrade/experimental.manifest

if [[ "$BRANCH" == "beta" ]] || [[ "$BRANCH" == "stable" ]]
then
	echo -e "contrib/sign.sh $SIGNING_KEY output/images/sysupgrade/beta.manifest"
	contrib/sign.sh $SIGNING_KEY output/images/sysupgrade/beta.manifest
fi

if [[ "$BRANCH" == "stable" ]]
then
	echo -e "contrib/sign.sh $SIGNING_KEY output/images/sysupgrade/stable.manifest"
	contrib/sign.sh $SIGNING_KEY output/images/sysupgrade/stable.manifest
fi
cd site
echo "Done :)"