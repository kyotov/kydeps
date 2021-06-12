#[[ -------------------------------------------

zstd
GIT_REPOSITORY
https://github.com/facebook/zstd.git
GIT_TAG
v1.4.7
REVISION
645a2975c394dc115b57a652cf175cd4c2b59292
FLAVOR
64-bit Windows Release
HASH
0132dfe5a67fa77260dec2c6bdd060395a6f24e6

-------------------------------------------- ]]

include_guard(GLOBAL)


KyDepsPopulate("zstd"
    "file://C:/kamen/clion/kydeps_new/cmake-build-release/_/zstd_0132dfe5a67fa77260dec2c6bdd060395a6f24e6/package.zip"
    "00d1417dbf9565a7dc4f636cd64480cc29147d94")

list(APPEND CMAKE_PREFIX_PATH "${CMAKE_BINARY_DIR}/.deps/zstd/zstd_0132dfe5a67fa77260dec2c6bdd060395a6f24e6/install")

find_package(zstd REQUIRED NO_MODULE)
