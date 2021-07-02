include_guard(GLOBAL)

include(openssl)

KyDepsInstall(httplib
        GIT_REPOSITORY https://github.com/kyotov/cpp-httplib.git
        GIT_REF 2e4fbb5c286a3cad5e7f88304ffc0acfe2b8575c # v0.8.9-windows-patch

        CMAKE_ARGS
        -DOPENSSL_USE_STATIC_LIBS=ON

        DEPENDS OpenSSL)
