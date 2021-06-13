#[[ -------------------------------------------

zlib
GIT_REPOSITORY
https://github.com/kyotov/zlib.git
GIT_TAG
kyotov-fix
REVISION
68cf39d20a32cf9659e62b10f95fccc0575b0b31
FLAVOR
64-bit Windows Debug
HASH
e6f55327533b4cbea5a411bb8dca73864c349b76

-------------------------------------------- ]]

include_guard(GLOBAL)


KyDepsPopulate(zlib e6f55327533b4cbea5a411bb8dca73864c349b76
    "file://C:/kamen/clion/kydeps_new/cmake-build-debug/_/zlib_e6f55327533b4cbea5a411bb8dca73864c349b76/package.zip"
    559455dc90441a6f3b5a852352a0bb9c77eb2159)

list(APPEND CMAKE_PREFIX_PATH "${CMAKE_BINARY_DIR}/.deps/zlib/zlib_e6f55327533b4cbea5a411bb8dca73864c349b76/install")

find_package(zlib REQUIRED NO_MODULE)
