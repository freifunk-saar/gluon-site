#!/bin/bash
# This file prints the current version number.  When sources, it also sets some environment variables.
# $1 is used to determine whether we use an experimental, beta, or stable version

# This is where we control which Gluon version to use.
export GLUON_UPSTREAM_TAG="v2017.1.8"

# This is where we control the version number of our firmware.
CURRENT_VERSION="1.7.0"
CURRENT_BETA_SUFFIX="~rc1"
CURRENT_EXPERIMENTAL_SUFFIX="~exp$(date '+%Y%m%d')"

###################################################################################################
## Do NOT change anything below here!
# Now we compute the actual version number.

if [[ "$1" == "stable" ]]; then
        export RELEASE_VERSION=${CURRENT_VERSION}
elif [[ "$1" == "beta" ]]; then
        export RELEASE_VERSION=${CURRENT_VERSION}${CURRENT_BETA_SUFFIX}
else # experimental branch and local builds
        export RELEASE_VERSION=${CURRENT_VERSION}${CURRENT_EXPERIMENTAL_SUFFIX}
fi

export RELEASE_TAG=$(echo "${RELEASE_VERSION}" | tr '~' '-')

echo "$RELEASE_VERSION"
