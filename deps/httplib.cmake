include_guard(GLOBAL)

include(openssl)

KyDepsInstall(httplib
        GIT_REPOSITORY https://github.com/kyotov/cpp-httplib.git
        GIT_REF v0.8.9-windows-patch

        CMAKE_ARGS
        -DOPENSSL_USE_STATIC_LIBS=ON

        DEPENDS OpenSSL)
