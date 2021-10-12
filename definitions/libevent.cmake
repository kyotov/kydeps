include_guard(GLOBAL)

include(openssl)
include(zlib)

KyDepsInstall(libevent
        GIT_REPOSITORY https://github.com/libevent/libevent.git
        GIT_REF 5df3037d10556bfcb675bc73e516978b75fc7bc7 # release-2.1.12-stable

	CMAKE_ARGS
	-DEVENT__LIBRARY_TYPE=STATIC
	-DEVENT__DISABLE_REGRESS=ON # this does not work on windows without hand-adding crypt32.lib -- maybe upstream?

	DEPENDS OpenSSL zlib)