#[[ -------------------------------------------

zstd
GIT_REPOSITORY
https://github.com/facebook/zstd.git
GIT_TAG
v1.4.7
REVISION
645a2975c394dc115b57a652cf175cd4c2b59292
FLAVOR
64-bit Windows Debug
HASH
1c0d396f25037c7ee5c9519d0439fec6601b1dca

-------------------------------------------- ]]

include_guard(GLOBAL)


KyDepsPopulate(zstd 1c0d396f25037c7ee5c9519d0439fec6601b1dca
    "file://C:/kamen/clion/kydeps_new/cmake-build-debug/_/zstd_1c0d396f25037c7ee5c9519d0439fec6601b1dca/package.zip"
    23e5575bec5cc35609fd30f5e21d1642d8918f0c)

list(APPEND CMAKE_PREFIX_PATH "${CMAKE_BINARY_DIR}/.deps/zstd/zstd_1c0d396f25037c7ee5c9519d0439fec6601b1dca/install")

find_package(zstd REQUIRED NO_MODULE)
