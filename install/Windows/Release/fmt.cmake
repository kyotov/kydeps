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


KyDepsPopulate("fmt"
    "file://C:/kamen/clion/kydeps_new/cmake-build-release/_/fmt_09145a3eb2d80f19b94ecba661030cb656363ea1/package.zip"
    "732341306f9e6bec49e329cdc96e395a1d439bb5")

list(APPEND CMAKE_PREFIX_PATH "${CMAKE_BINARY_DIR}/.deps/fmt/fmt_09145a3eb2d80f19b94ecba661030cb656363ea1/install")

find_package(fmt REQUIRED NO_MODULE)
