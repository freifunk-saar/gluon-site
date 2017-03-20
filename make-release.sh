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

# if version is unset, will use the default experimental version from site.mk
VERSION=${3:-"exp$(date '+%Y%m%d')"}
# branch must be set to either experimental, beta or stable
BRANCH=${2:-"experimental"}
# must point to valid ecdsa signing key created by ecdsakeygen, relative to Gluon base directory
SIGNING_KEY=${1:-"../ecdsa-key-secret"}
# Gluon doesn't like being built as root unless this is set:
#export FORCE_UNSAFE_CONFIGURE=1

cd ..
if [ ! -d "site" ]; then
	echo "This script must be called from within the site directory"
	return
fi

rm -f build.log
rm -rf output
for TARGET in  ar71xx-generic ar71xx-nand brcm2708-bcm2708 brcm2708-bcm2709 mpc85xx-generic x86-generic x86-kvm_guest x86-64 x86-xen_domu
do
	echo "Starting work on target $TARGET" | tee -a build.log
	echo -e "\n\n\nmake GLUON_TARGET=$TARGET GLUON_BRANCH=stable GLUON_RELEASE=$VERSION update" | tee -a build.log
	make GLUON_TARGET=$TARGET GLUON_BRANCH=stable GLUON_RELEASE=$VERSION update 2>&1 | tee -a build.log
	echo -e "\n\n\nmake GLUON_TARGET=$TARGET GLUON_BRANCH=stable GLUON_RELEASE=$VERSION clean" | tee -a build.log
	make GLUON_TARGET=$TARGET GLUON_BRANCH=stable GLUON_RELEASE=$VERSION -j9 clean 2>&1 | tee -a build.log
	echo -e "\n\n\nmake GLUON_TARGET=$TARGET GLUON_BRANCH=stable GLUON_RELEASE=$VERSION -j9" | tee -a build.log
	make GLUON_TARGET=$TARGET GLUON_BRANCH=stable GLUON_RELEASE=$VERSION -j9 2>&1 | tee -a build.log
	echo -e "\n\n\n============================================================\n\n" | tee -a build.log
done
echo "Compilation complete, creating manifest(s)" | tee -a build.log

echo -e "make GLUON_BRANCH=experimental manifest" | tee -a build.log
make GLUON_BRANCH=experimental manifest 2>&1 | tee -a build.log
echo -e "\n\n\n============================================================\n\n" | tee -a build.log

if [[ "$BRANCH" == "beta" ]] || [[ "$BRANCH" == "stable" ]]
then
	echo -e "make GLUON_BRANCH=beta manifest" | tee -a build.log
	make GLUON_BRANCH=beta manifest 2>&1 | tee -a build.log
	echo -e "\n\n\n============================================================\n\n" | tee -a build.log
fi

if [[ "$BRANCH" == "stable" ]]
then
	echo -e "make GLUON_BRANCH=stable manifest" | tee -a build.log
	make GLUON_BRANCH=stable manifest 2>&1 | tee -a build.log
	echo -e "\n\n\n============================================================\n\n" | tee -a build.log
fi

echo "Manifest creation complete, signing manifest"

echo -e "contrib/sign.sh $SIGNING_KEY output/images/sysupgrade/experimental.manifest" | tee -a build.log
contrib/sign.sh $SIGNING_KEY output/images/sysupgrade/experimental.manifest 2>&1 | tee -a build.log

if [[ "$BRANCH" == "beta" ]] || [[ "$BRANCH" == "stable" ]]
then
	echo -e "contrib/sign.sh $SIGNING_KEY output/images/sysupgrade/beta.manifest" | tee -a build.log
	contrib/sign.sh $SIGNING_KEY output/images/sysupgrade/beta.manifest 2>&1 | tee -a build.log
fi

if [[ "$BRANCH" == "stable" ]]
then
	echo -e "contrib/sign.sh $SIGNING_KEY output/images/sysupgrade/stable.manifest" | tee -a build.log
	contrib/sign.sh $SIGNING_KEY output/images/sysupgrade/stable.manifest 2>&1 | tee -a build.log
fi
cd site
echo "Done :)"
