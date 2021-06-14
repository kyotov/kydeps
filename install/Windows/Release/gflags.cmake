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
    "https://kydeps.s3.us-east-2.amazonaws.com/gflags_532cf33544f6adf420c66b2f72d265499cb00d75.zip"
    ca3444474b6648305529f38534eaea608251c440)

list(APPEND CMAKE_PREFIX_PATH "${CMAKE_BINARY_DIR}/.deps/gflags/gflags_532cf33544f6adf420c66b2f72d265499cb00d75/install")

find_package(gflags REQUIRED NO_MODULE)
