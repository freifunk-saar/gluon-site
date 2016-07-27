if [[ "$CI_BUILD_REF_NAME" == "master" ]] || [[ -z ${CI_BUILD_REF_NAME+x} ]]
then
	echo "Builds from master branch are not allowed"
	exit 1;
fi

export GLUON_UPSTREAM_TAG="v2016.1.5"

CURRENT_VERSION="1.3.1"
CURRENT_BETA_SUFFIX="~rc2"
CURRENT_EXPERIMENTAL_SUFFIX="~exp$(date '+%Y%m%d')"

RELEASE_VERSION=${CURRENT_VERSION}


if [[ "$CI_BUILD_REF_NAME" == "beta" ]]
then
        RELEASE_VERSION=${RELEASE_VERSION}${CURRENT_BETA_SUFFIX}
fi

if [[ "$CI_BUILD_REF_NAME" == "experimental" ]]
then
        RELEASE_VERSION=${RELEASE_VERSION}${CURRENT_EXPERIMENTAL_SUFFIX}
fi

export RELEASE_VERSION

echo "Building Gluon ${GLUON_UPSTREAM_TAG} for FFSAAR version ${RELEASE_VERSION} from the ${CI_BUILD_REF_NAME} branch"
