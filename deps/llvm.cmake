include_guard(GLOBAL)

if (FALSE)

    KyDepsInstall(llvm
            https://github.com/llvm/llvm-project.git
            main
            #        llvmorg-12.0.0

            SOURCE_SUBDIR llvm

            BUILD_COMMAND ${CMAKE_COMMAND} --build <BINARY_DIR> --target clang-tidy
            INSTALL_COMMAND ${CMAKE_COMMAND} --build <BINARY_DIR> --target install-clang-tidy

            CMAKE_CACHE_ARGS
            "-DLLVM_ENABLE_PROJECTS:LIST=clang;clang-tools-extra"
            "-DLLVM_TARGETS_TO_BUILD:LIST=X86")

endif ()
