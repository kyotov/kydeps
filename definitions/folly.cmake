include_guard(GLOBAL)

include(google/flags)
include(google/log)
include(google/double-conversion)
include(fmt)
include(libevent)
include(zlib)
include(openssl)
include(boost)

add_compile_options(-DGFLAGS_DLL_DEFINE_FLAG= -DGOOGLE_GLOG_DLL_DECL= -DNOMINMAX -DGLOG_NO_ABBREVIATED_SEVERITIES)

KyDepsInstall(folly
        GIT_REPOSITORY https://github.com/facebook/folly.git
        GIT_REF 5b38d6fa96ca8719970a28f9a87d245365dbf2ce # v2021.10.04.00

	CMAKE_ARGS
	-DBoost_USE_STATIC_LIBS=ON
	-DBoost_USE_STATIC_RUNTIME=ON

	DEPENDS gflags glog double-conversion fmt libevent zlib OpenSSL Boost)
