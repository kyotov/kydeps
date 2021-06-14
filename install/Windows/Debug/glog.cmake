#[[ -------------------------------------------

glog
GIT_REPOSITORY
https://github.com/google/glog.git
GIT_TAG
v0.4.0
REVISION
96a2f23dca4cc7180821ca5f32e526314395d26a
FLAVOR
64-bit Windows Debug
DEPENDS
gflags 112e3ec543485c0088707a8ff5cba6ceaf90da42
HASH
1c0dbb59f1380a5097722edb97aec55a48f2421c

-------------------------------------------- ]]

include_guard(GLOBAL)

include(gflags)

KyDepsPopulate(glog 1c0dbb59f1380a5097722edb97aec55a48f2421c
    "https://kydeps.s3.us-east-2.amazonaws.com/glog_1c0dbb59f1380a5097722edb97aec55a48f2421c.zip"
    313995297d2ad470de389675b8cae8cd73979e4e)

list(APPEND CMAKE_PREFIX_PATH "${CMAKE_BINARY_DIR}/.deps/glog/glog_1c0dbb59f1380a5097722edb97aec55a48f2421c/install")

find_package(glog REQUIRED NO_MODULE)
