##	gluon site.mk makefile example

##	GLUON_SITE_PACKAGES
#		specify gluon/openwrt packages to include here
#               The gluon-mesh-batman-adv-* package must come first because of the dependency resolution

GLUON_SITE_PACKAGES := \
	gluon-mesh-batman-adv-15 \
	gluon-respondd \
	gluon-autoupdater \
	gluon-config-mode-autoupdater \
	gluon-config-mode-contact-info \
	gluon-config-mode-hostname \
	gluon-config-mode-mesh-vpn \
	gluon-config-mode-geo-location \
	gluon-ebtables-filter-multicast \
	gluon-ebtables-filter-ra-dhcp \
	gluon-ebtables-source-filter \
	gluon-ebtables-limit-arp \
	gluon-web-admin \
	gluon-web-autoupdater \
	gluon-web-network \
	gluon-web-wifi-config \
	gluon-web-private-wifi \
	gluon-mesh-vpn-tunneldigger \
	gluon-radvd \
	gluon-radv-filterd \
	gluon-status-page \
	respondd-module-airtime \
	iwinfo \
	iptables \
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

# ath10k choice
GLUON_ATH10K_MESH ?= 11s
