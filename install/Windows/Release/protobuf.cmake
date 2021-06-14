#[[ -------------------------------------------

protobuf
GIT_REPOSITORY
https://github.com/protocolbuffers/protobuf.git
GIT_TAG
v3.15.8
REVISION
436bd7880e458532901c58f4d9d1ea23fa7edd52
FLAVOR
64-bit Windows Release
DEPENDS
zlib 4a15cbcf43f21de70dd12e83cda940413a88b76e
HASH
532c4e282d3326954391ee48aa83a7115eb4c22a

-------------------------------------------- ]]

include_guard(GLOBAL)

include(zlib)

KyDepsPopulate(protobuf 532c4e282d3326954391ee48aa83a7115eb4c22a
    "file://C:/kamen/clion/kydeps_new/build/Release/_/protobuf_532c4e282d3326954391ee48aa83a7115eb4c22a/package.zip"
    1c360689cbe807548d87368e2dc5d197ce550799)

list(APPEND CMAKE_PREFIX_PATH "${CMAKE_BINARY_DIR}/.deps/protobuf/protobuf_532c4e282d3326954391ee48aa83a7115eb4c22a/install")

find_package(protobuf REQUIRED NO_MODULE)
