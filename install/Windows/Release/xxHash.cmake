#[[ -------------------------------------------

xxHash
GIT_REPOSITORY
https://github.com/Cyan4973/xxHash.git
GIT_TAG
v0.8.0
REVISION
94e5f23e736f2bb67ebdf90727353e65344f9fc0
FLAVOR
64-bit Windows Release
HASH
fd879d41ee597b60b7bac6a811894c186b695967

-------------------------------------------- ]]

include_guard(GLOBAL)


KyDepsPopulate("xxhash"
    "file://C:/kamen/clion/kydeps_new/cmake-build-release/_/xxHash_fd879d41ee597b60b7bac6a811894c186b695967/package.zip"
    "99409292867ace8d4594b9d2f7ede3544021b3df")

list(APPEND CMAKE_PREFIX_PATH "${CMAKE_BINARY_DIR}/.deps/xxhash/xxHash_fd879d41ee597b60b7bac6a811894c186b695967/install")

find_package(xxHash REQUIRED NO_MODULE)
