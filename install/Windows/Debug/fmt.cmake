#[[ -------------------------------------------

fmt
GIT_REPOSITORY
https://github.com/fmtlib/fmt.git
GIT_TAG
7.1.3
REVISION
7bdf0628b1276379886c7f6dda2cef2b3b374f0b
FLAVOR
64-bit Windows Debug
HASH
ac8e0dca5820ee37fc9e527f9b3838fdebf265b1

-------------------------------------------- ]]

include_guard(GLOBAL)


KyDepsPopulate("fmt"
    "file://C:/kamen/clion/kydeps_new/cmake-build-debug/_/fmt_ac8e0dca5820ee37fc9e527f9b3838fdebf265b1/package.zip"
    "72d02ce8ec8dc8b860f60c2a97cc25dcf7c03bad")

list(APPEND CMAKE_PREFIX_PATH "${CMAKE_BINARY_DIR}/.deps/fmt/fmt_ac8e0dca5820ee37fc9e527f9b3838fdebf265b1/install")

find_package(fmt REQUIRED NO_MODULE)
