#[[ -------------------------------------------

llvm
GIT_REPOSITORY
https://github.com/llvm/llvm-project.git
GIT_TAG
main
REVISION
152c9871e6ac7ba2a14dcc64e812b79193421846
FLAVOR
64-bit Windows Release
HASH
7f1a79df62f766a811d3d728c3c4c90b664fae16

-------------------------------------------- ]]

include_guard(GLOBAL)


KyDepsPopulate(llvm 7f1a79df62f766a811d3d728c3c4c90b664fae16
    "file://C:/kamen/clion/kydeps_new/build/Release/_/llvm_7f1a79df62f766a811d3d728c3c4c90b664fae16/package.zip"
    7abcd4e5f997f872ce796ef5ed8cc738cdb5e555)

list(APPEND CMAKE_PREFIX_PATH "${CMAKE_BINARY_DIR}/.deps/llvm/llvm_7f1a79df62f766a811d3d728c3c4c90b664fae16/install")

find_program(CLANG_TIDY REQUIRED NAMES clang-tidy)
