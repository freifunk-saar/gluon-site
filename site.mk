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
	radvd \
	respondd \
	web-wizard \
	web-advanced \
	web-private-wifi \
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
	haveged

##	DEFAULT_GLUON_RELEASE
#		version string to use for images
#		gluon relies on
#			opkg compare-versions "$1" '>>' "$2"
#		to decide if a version is newer or not.

DEFAULT_GLUON_RELEASE := $(shell $(GLUON_SITEDIR)/version.sh)

##	GLUON_RELEASE
#		call make with custom GLUON_RELEASE flag, to use your own release version scheme.
#		e.g.:
#			$ make images GLUON_RELEASE=23.42+5
#		would generate images named like this:
#			gluon-ff%site_code%-23.42+5-%router_model%.bin

# Allow overriding the release number from the command line
GLUON_RELEASE ?= $(DEFAULT_GLUON_RELEASE)

# Default priority for updates.
GLUON_PRIORITY ?= 1

# Languages to include
GLUON_LANGS ?= en de fr

# TP-LINK regional firmware
GLUON_REGION ?= eu

# We use 11s for the mesh, not the old IBSS
GLUON_WLAN_MESH ?= 11s
