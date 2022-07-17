##	GLUON_FEATURES
#		Specify Gluon features/packages to enable;
#		Gluon will automatically enable a set of packages
#		depending on the combination of features listed

GLUON_FEATURES := \
	autoupdater \
	mesh-batman-adv-15 \
	mesh-vpn-tunneldigger \
	ebtables-filter-multicast \
	ebtables-filter-ra-dhcp \
	ebtables-source-filter \
	ebtables-limit-arp \
	radv-filterd \
	respondd \
	web-wizard \
	web-advanced \
	web-private-wifi \
	wireless-encryption-wpa3 \
	config-mode-geo-location-osm \
	status-page

##	GLUON_SITE_PACKAGES
#		Specify additional Gluon/LEDE packages to include here;
#		A minus sign may be prepended to remove a packages from the
#		selection that would be enabled by default or due to the
#		chosen feature flags

GLUON_SITE_PACKAGES := \
	respondd-module-airtime \
	iwinfo \
	gluon-ffsaar-watchdog \
	gluon-config-mode-domain-select \
	ffda-domain-director \
	gluon-web-ffda-domain-director

##	DEFAULT_GLUON_RELEASE
#		version string to use for images
#		gluon relies on
#			opkg compare-versions "$1" '>>' "$2"
#		to decide if a version is newer or not.

DEFAULT_GLUON_RELEASE := $(shell $(GLUON_SITEDIR)/version.sh)

# Enable multo-domain support.
GLUON_MULTIDOMAIN := 1

# Set release number.
# Using `?=` to allow overriding the release number from the command line.
GLUON_RELEASE ?= $(DEFAULT_GLUON_RELEASE)

# Default priority for updates.
GLUON_PRIORITY ?= 1

# Languages to include
GLUON_LANGS ?= en de fr

# TP-LINK regional firmware
GLUON_REGION ?= eu

# We have lots of these deprecated devices so support them as long as we can...
GLUON_DEPRECATED ?= full
