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
    "file://C:/kamen/clion/kydeps_new/build/Debug/_/zlib_e6f55327533b4cbea5a411bb8dca73864c349b76/package.zip"
    4fa347a6527d8356e561b7cbd228cf0fba40adaf)

list(APPEND CMAKE_PREFIX_PATH "${CMAKE_BINARY_DIR}/.deps/zlib/zlib_e6f55327533b4cbea5a411bb8dca73864c349b76/install")

find_package(zlib REQUIRED NO_MODULE)
