#[[ -------------------------------------------

GTest
GIT_REPOSITORY
https://github.com/google/googletest.git
GIT_TAG
release-1.10.0
REVISION
703bd9caab50b139428cea1aaff9974ebee5742e
FLAVOR
64-bit Windows Debug
HASH
2ec40d9c2b205cdb6eaaf713815782d66598788d

-------------------------------------------- ]]

include_guard(GLOBAL)


KyDepsPopulate("gtest"
    "file://C:/kamen/clion/kydeps_new/cmake-build-debug/_/GTest_2ec40d9c2b205cdb6eaaf713815782d66598788d/package.zip"
    "cb45319ef3b267c7d63d4582823da97194aabd8f")

list(APPEND CMAKE_PREFIX_PATH "${CMAKE_BINARY_DIR}/.deps/gtest/GTest_2ec40d9c2b205cdb6eaaf713815782d66598788d/install")

find_package(GTest REQUIRED NO_MODULE)
