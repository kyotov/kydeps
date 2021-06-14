#[[ -------------------------------------------

glog
GIT_REPOSITORY
https://github.com/google/glog.git
GIT_TAG
v0.4.0
REVISION
96a2f23dca4cc7180821ca5f32e526314395d26a
FLAVOR
64-bit Windows Release
DEPENDS
gflags 532cf33544f6adf420c66b2f72d265499cb00d75
HASH
f8a10f76b16104163f7bc499b17e872dd4f944f6

-------------------------------------------- ]]

include_guard(GLOBAL)

include(gflags)

KyDepsPopulate(glog f8a10f76b16104163f7bc499b17e872dd4f944f6
    "https://kydeps.s3.us-east-2.amazonaws.com/glog_f8a10f76b16104163f7bc499b17e872dd4f944f6.zip"
    813ca70e2ac581d691e625399bbbf60ebd8fece5)

list(APPEND CMAKE_PREFIX_PATH "${CMAKE_BINARY_DIR}/.deps/glog/glog_f8a10f76b16104163f7bc499b17e872dd4f944f6/install")

find_package(glog REQUIRED NO_MODULE)
