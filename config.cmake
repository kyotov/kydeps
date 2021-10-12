set(KYDEPS_QUICK OFF
        CACHE BOOL "download from s3" FORCE)

set(BUILD_TYPES Debug
	CACHE STRING "build types to build" FORCE)

set(_KYDEPS_PACKAGES
#	folly
#	libevent
#	watchman
	google/log
        CACHE STRING "packages to build" FORCE)
