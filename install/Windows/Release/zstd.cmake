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


KyDepsPopulate(zstd 0132dfe5a67fa77260dec2c6bdd060395a6f24e6
    "file://C:/kamen/clion/kydeps_new/build/Release/_/zstd_0132dfe5a67fa77260dec2c6bdd060395a6f24e6/package.zip"
    431c85889ca4062700ee9f0768b49792101da6e5)

list(APPEND CMAKE_PREFIX_PATH "${CMAKE_BINARY_DIR}/.deps/zstd/zstd_0132dfe5a67fa77260dec2c6bdd060395a6f24e6/install")

find_package(zstd REQUIRED NO_MODULE)
