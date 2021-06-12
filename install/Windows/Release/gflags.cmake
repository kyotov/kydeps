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


KyDepsPopulate("gflags"
    "file://C:/kamen/clion/kydeps_new/cmake-build-release/_/gflags_532cf33544f6adf420c66b2f72d265499cb00d75/package.zip"
    "5093316e36eb0d406f059ff650674df4912bff33")

list(APPEND CMAKE_PREFIX_PATH "${CMAKE_BINARY_DIR}/.deps/gflags/gflags_532cf33544f6adf420c66b2f72d265499cb00d75/install")

find_package(gflags REQUIRED NO_MODULE)
