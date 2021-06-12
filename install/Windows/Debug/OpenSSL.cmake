#[[ -------------------------------------------

OpenSSL
GIT_REPOSITORY
https://github.com/openssl/openssl.git
GIT_TAG
OpenSSL_1_1_1k
REVISION
fd78df59b0f656aefe96e39533130454aa957c00
FLAVOR
64-bit Windows Debug
DEPENDS
perl 8970b13fd773396129a83c86df4bf3aed4e08e58
DEPENDS
zlib e6f55327533b4cbea5a411bb8dca73864c349b76
HASH
ac910f55f9b60f5b6d08724a136603ad18f007c7

-------------------------------------------- ]]

include_guard(GLOBAL)

include(perl)
include(zlib)

KyDepsPopulate("openssl"
    "file://C:/kamen/clion/kydeps_new/cmake-build-debug/_/OpenSSL_ac910f55f9b60f5b6d08724a136603ad18f007c7/package.zip"
    "2213d9ebf1ce35681e19af33c92d88863de0f7d7")

list(APPEND CMAKE_PREFIX_PATH "${CMAKE_BINARY_DIR}/.deps/openssl/OpenSSL_ac910f55f9b60f5b6d08724a136603ad18f007c7/install")

find_package(OpenSSL REQUIRED MODULE)
