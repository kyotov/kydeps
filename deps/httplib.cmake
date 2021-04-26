include_guard(GLOBAL)

include(openssl)

KyDepsInstall(
        https://github.com/kyotov/cpp-httplib.git
        v0.8.8-windows-patch

        DEPENDS openssl

        CMAKE_ARGS
        -DOPENSSL_USE_STATIC_LIBS=ON)
