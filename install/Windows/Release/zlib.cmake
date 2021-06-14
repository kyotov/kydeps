#[[ -------------------------------------------

zlib
GIT_REPOSITORY
https://github.com/kyotov/zlib.git
GIT_TAG
kyotov-fix
REVISION
68cf39d20a32cf9659e62b10f95fccc0575b0b31
FLAVOR
64-bit Windows Release
HASH
4a15cbcf43f21de70dd12e83cda940413a88b76e

-------------------------------------------- ]]

include_guard(GLOBAL)


KyDepsPopulate(zlib 4a15cbcf43f21de70dd12e83cda940413a88b76e
    "https://kydeps.s3.us-east-2.amazonaws.com/zlib_4a15cbcf43f21de70dd12e83cda940413a88b76e.zip"
    8709736ea3cffdec9a068e677678330e7cbd93e2)

list(APPEND CMAKE_PREFIX_PATH "${CMAKE_BINARY_DIR}/.deps/zlib/zlib_4a15cbcf43f21de70dd12e83cda940413a88b76e/install")

find_package(zlib REQUIRED NO_MODULE)
