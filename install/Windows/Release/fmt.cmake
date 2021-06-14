#[[ -------------------------------------------

fmt
GIT_REPOSITORY
https://github.com/fmtlib/fmt.git
GIT_TAG
7.1.3
REVISION
7bdf0628b1276379886c7f6dda2cef2b3b374f0b
FLAVOR
64-bit Windows Release
HASH
09145a3eb2d80f19b94ecba661030cb656363ea1

-------------------------------------------- ]]

include_guard(GLOBAL)


KyDepsPopulate(fmt 09145a3eb2d80f19b94ecba661030cb656363ea1
    "https://kydeps.s3.us-east-2.amazonaws.com/fmt_09145a3eb2d80f19b94ecba661030cb656363ea1.zip"
    c612709913a1ac8e77a2d7e4c4a0d34785a02391)

list(APPEND CMAKE_PREFIX_PATH "${CMAKE_BINARY_DIR}/.deps/fmt/fmt_09145a3eb2d80f19b94ecba661030cb656363ea1/install")

find_package(fmt REQUIRED NO_MODULE)
