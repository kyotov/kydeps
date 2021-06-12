#[[ -------------------------------------------

xxHash
GIT_REPOSITORY
https://github.com/Cyan4973/xxHash.git
GIT_TAG
v0.8.0
REVISION
94e5f23e736f2bb67ebdf90727353e65344f9fc0
FLAVOR
64-bit Windows Debug
HASH
341d3d002bd310fb4a7eb2720617bf908301c588

-------------------------------------------- ]]

include_guard(GLOBAL)


KyDepsPopulate("xxhash"
    "file://C:/kamen/clion/kydeps_new/cmake-build-debug/_/xxHash_341d3d002bd310fb4a7eb2720617bf908301c588/package.zip"
    "46f4352e7191f9d0fb09591105d396078f9eef3c")

list(APPEND CMAKE_PREFIX_PATH "${CMAKE_BINARY_DIR}/.deps/xxhash/xxHash_341d3d002bd310fb4a7eb2720617bf908301c588/install")

find_package(xxHash REQUIRED NO_MODULE)
