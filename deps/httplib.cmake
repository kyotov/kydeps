include_guard(GLOBAL)

include(openssl)

KyDepsInstall(
        https://github.com/yhirose/cpp-httplib.git
        v0.8.4

        DEPENDS openssl

        CMAKE_ARGS
        -DOPENSSL_USE_STATIC_LIBS=ON)
