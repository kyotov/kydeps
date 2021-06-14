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

include(zlib)

KyDepsPopulate(OpenSSL ac910f55f9b60f5b6d08724a136603ad18f007c7
    "https://kydeps.s3.us-east-2.amazonaws.com/OpenSSL_ac910f55f9b60f5b6d08724a136603ad18f007c7.zip"
    8633c2efdd5a5d61158ce8843a9247804a9854c7)

list(APPEND CMAKE_PREFIX_PATH "${CMAKE_BINARY_DIR}/.deps/OpenSSL/OpenSSL_ac910f55f9b60f5b6d08724a136603ad18f007c7/install")

find_package(OpenSSL REQUIRED)
