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


KyDepsPopulate("zlib"
    "file://C:/kamen/clion/kydeps_new/cmake-build-debug/_/zlib_e6f55327533b4cbea5a411bb8dca73864c349b76/package.zip"
    "ec29bcb6a071fc031c83c943e8f7b5187551b3ee")

list(APPEND CMAKE_PREFIX_PATH "${CMAKE_BINARY_DIR}/.deps/zlib/zlib_e6f55327533b4cbea5a411bb8dca73864c349b76/install")

find_package(zlib REQUIRED NO_MODULE)
