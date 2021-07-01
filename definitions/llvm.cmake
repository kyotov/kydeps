include_guard(GLOBAL)

set(llvm_BUILD_TYPE_OVERRIDE "Release")
set(llvm_FIND_OVERRIDE [[find_program(CLANG_TIDY REQUIRED NAMES clang-tidy)]])

KyDepsInstall(llvm
        GIT_REPOSITORY https://github.com/llvm/llvm-project.git
        GIT_REF 28b01c59c93d10ed3a775dd13ff827048b59cda8 # latest for 2021-06-30

        SOURCE_SUBDIR llvm

        BUILD_COMMAND ${CMAKE_COMMAND} --build <BINARY_DIR> --target clang-tidy
        INSTALL_COMMAND ${CMAKE_COMMAND} --build <BINARY_DIR> --target install-clang-tidy tools/clang/lib/Headers/install

        CMAKE_CACHE_ARGS
        "-DLLVM_ENABLE_PROJECTS:STRING=clang;clang-tools-extra"
        # TODO(kyotov): make sure this works for non-x86?
        "-DLLVM_TARGETS_TO_BUILD:STRING=X86")
