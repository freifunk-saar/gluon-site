#!/bin/bash
# Install a custom banner for our firmware.
if [ ! -d "site" ]; then
	echo "This script must be called from within the gluon directory"
	exit 1
fi
if [ -z "$RELEASE_VERSION" ]; then
    RELEASE_VERSION=$(site/version.sh)
fi

cat >openwrt/package/base-files/files/etc/banner <<EOF
  _____  _____
_/ ____\\/ ____\\___________  _____ _______
\\   __\\\\   __\\/  ___/\\__  \\ \\__  \\\\_  ___\\
 |  |   |  |  \\___ \\  / __ \\_/ __ \\|  |
 |__|   |__| /_____/ (_____/(_____//__|
 -----------------------------------------------------
 %D %V, %C
 gluon-ffsaar $RELEASE_VERSION / gluon $(git describe | sed -E 's/-g([a-z0-9]{7})/-\1/')
 -----------------------------------------------------
 Gluon commandline administration reference:
 https://github.com/freifunk-gluon/gluon/wiki/Commandline-administration
 -----------------------------------------------------
EOF
