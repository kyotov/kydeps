#[[ -------------------------------------------

GTest
GIT_REPOSITORY
https://github.com/google/googletest.git
GIT_TAG
release-1.10.0
REVISION
703bd9caab50b139428cea1aaff9974ebee5742e
FLAVOR
64-bit Windows Release
HASH
d9d1d8687800613f9bae648c2ff75a90c213675c

-------------------------------------------- ]]

include_guard(GLOBAL)


KyDepsPopulate("gtest"
    "file://C:/kamen/clion/kydeps_new/cmake-build-release/_/GTest_d9d1d8687800613f9bae648c2ff75a90c213675c/package.zip"
    "dd86316f233ddfcf31f610365e5804ee65a89577")

list(APPEND CMAKE_PREFIX_PATH "${CMAKE_BINARY_DIR}/.deps/gtest/GTest_d9d1d8687800613f9bae648c2ff75a90c213675c/install")

find_package(GTest REQUIRED NO_MODULE)
