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
    "file://C:/kamen/clion/kydeps_new/cmake-build-debug/_/glog_1c0dbb59f1380a5097722edb97aec55a48f2421c/package.zip"
    ba1c912d5ae0fdee8e9570f98d688f01f3a357f2)

list(APPEND CMAKE_PREFIX_PATH "${CMAKE_BINARY_DIR}/.deps/glog/glog_1c0dbb59f1380a5097722edb97aec55a48f2421c/install")

find_package(glog REQUIRED NO_MODULE)
