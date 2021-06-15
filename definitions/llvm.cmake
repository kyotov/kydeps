include_guard(GLOBAL)

set(llvm_BUILD_TYPE_OVERRIDE "Release")
set(llvm_FIND_OVERRIDE [[find_program(CLANG_TIDY REQUIRED NAMES clang-tidy)]])

KyDepsInstall(llvm
        GIT_REPOSITORY https://github.com/llvm/llvm-project.git
        GIT_REF main
        #        llvmorg-12.0.0

        SOURCE_SUBDIR llvm

        BUILD_COMMAND ${CMAKE_COMMAND} --build <BINARY_DIR> --target clang-tidy
        INSTALL_COMMAND ${CMAKE_COMMAND} --build <BINARY_DIR> --target install-clang-tidy tools/clang/lib/Headers

        CMAKE_CACHE_ARGS
        "-DLLVM_ENABLE_PROJECTS:LIST=clang;clang-tools-extra"
        "-DLLVM_TARGETS_TO_BUILD:LIST=X86")
