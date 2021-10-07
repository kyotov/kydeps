set(KYDEPS_QUICK OFF
        CACHE BOOL "download from s3" FORCE)

set(BUILD_TYPES Debug 
	CACHE STRING "build types to build" FORCE)

set(KYDEPS_PACKAGES
	folly
#	libevent
        CACHE STRING "packages to build" FORCE)
