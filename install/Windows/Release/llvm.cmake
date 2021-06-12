#[[ -------------------------------------------

llvm
GIT_REPOSITORY
https://github.com/llvm/llvm-project.git
GIT_TAG
main
REVISION
0a0800c4d10c250ffb152b5f059d6f9a19ed8efe
FLAVOR
64-bit Windows Release
HASH
a25bb7a5ff95ee19b2adf5f5d8d379e46ebb1b4d

-------------------------------------------- ]]

include_guard(GLOBAL)


KyDepsPopulate("llvm"
    "file://C:/kamen/clion/kydeps_new/cmake-build-release/_/llvm_a25bb7a5ff95ee19b2adf5f5d8d379e46ebb1b4d/package.zip"
    "9e9c40b2fe465f1bd3d473780e21daca7a079afa")

list(APPEND CMAKE_PREFIX_PATH "${CMAKE_BINARY_DIR}/.deps/llvm/llvm_a25bb7a5ff95ee19b2adf5f5d8d379e46ebb1b4d/install")

find_package(llvm REQUIRED NO_MODULE)
