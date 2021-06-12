#[[ -------------------------------------------

OpenSSL
GIT_REPOSITORY
https://github.com/openssl/openssl.git
GIT_TAG
OpenSSL_1_1_1k
REVISION
fd78df59b0f656aefe96e39533130454aa957c00
FLAVOR
64-bit Windows Release
DEPENDS
perl fc6dec7e8728ff02b2f044baa7d5b14b215f52ca
DEPENDS
zlib 4a15cbcf43f21de70dd12e83cda940413a88b76e
HASH
47e39a4fec1130d9be561c1056a305e8bed34e46

-------------------------------------------- ]]

include_guard(GLOBAL)

include(perl)
include(zlib)

KyDepsPopulate("openssl"
    "file://C:/kamen/clion/kydeps_new/cmake-build-release/_/OpenSSL_47e39a4fec1130d9be561c1056a305e8bed34e46/package.zip"
    "a36dbfccbdc6cdf59a39ad74d1afd9700ce05eb6")

list(APPEND CMAKE_PREFIX_PATH "${CMAKE_BINARY_DIR}/.deps/openssl/OpenSSL_47e39a4fec1130d9be561c1056a305e8bed34e46/install")

find_package(OpenSSL REQUIRED MODULE)
