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


KyDepsPopulate(GTest d9d1d8687800613f9bae648c2ff75a90c213675c
    "https://kydeps.s3.us-east-2.amazonaws.com/GTest_d9d1d8687800613f9bae648c2ff75a90c213675c.zip"
    4cca983ad6c978b318665e60f450e203cb5ab0c2)

list(APPEND CMAKE_PREFIX_PATH "${CMAKE_BINARY_DIR}/.deps/GTest/GTest_d9d1d8687800613f9bae648c2ff75a90c213675c/install")

find_package(GTest REQUIRED NO_MODULE)
