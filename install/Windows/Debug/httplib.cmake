#[[ -------------------------------------------

httplib
GIT_REPOSITORY
https://github.com/kyotov/cpp-httplib.git
GIT_TAG
v0.8.9-windows-patch
REVISION
2e4fbb5c286a3cad5e7f88304ffc0acfe2b8575c
FLAVOR
64-bit Windows Debug
DEPENDS
OpenSSL ac910f55f9b60f5b6d08724a136603ad18f007c7
HASH
1e95b768963423268995c832096c89edff5d8fba

-------------------------------------------- ]]

include_guard(GLOBAL)

include(OpenSSL)

KyDepsPopulate("httplib"
    "file://C:/kamen/clion/kydeps_new/cmake-build-debug/_/httplib_1e95b768963423268995c832096c89edff5d8fba/package.zip"
    "620de31e247d51c2409df6a3dd216cd7527f0565")

list(APPEND CMAKE_PREFIX_PATH "${CMAKE_BINARY_DIR}/.deps/httplib/httplib_1e95b768963423268995c832096c89edff5d8fba/install")

find_package(httplib REQUIRED NO_MODULE)
