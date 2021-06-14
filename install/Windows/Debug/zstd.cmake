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
    "file://C:/kamen/clion/kydeps_new/build/Debug/_/zstd_1c0d396f25037c7ee5c9519d0439fec6601b1dca/package.zip"
    0c988b3d6f3fdee05d2c0a86711634b92567480b)

list(APPEND CMAKE_PREFIX_PATH "${CMAKE_BINARY_DIR}/.deps/zstd/zstd_1c0d396f25037c7ee5c9519d0439fec6601b1dca/install")

find_package(zstd REQUIRED NO_MODULE)
