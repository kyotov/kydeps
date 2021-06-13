#[[ -------------------------------------------

gflags
GIT_REPOSITORY
https://github.com/gflags/gflags.git
GIT_TAG
v2.2.0
REVISION
f8a0efe03aa69b3336d8e228b37d4ccb17324b88
FLAVOR
64-bit Windows Release
HASH
532cf33544f6adf420c66b2f72d265499cb00d75

-------------------------------------------- ]]

include_guard(GLOBAL)


KyDepsPopulate(gflags 532cf33544f6adf420c66b2f72d265499cb00d75
    "file://C:/kamen/clion/kydeps_new/cmake-build-release/_/gflags_532cf33544f6adf420c66b2f72d265499cb00d75/package.zip"
    116d100c059b9b6dfab14d73bbc7181df2bc6e97)

list(APPEND CMAKE_PREFIX_PATH "${CMAKE_BINARY_DIR}/.deps/gflags/gflags_532cf33544f6adf420c66b2f72d265499cb00d75/install")

find_package(gflags REQUIRED NO_MODULE)
