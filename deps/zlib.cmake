include_guard(GLOBAL)

KyDepsInstall(https://github.com/kyotov/zlib.git v1.2.11-fix-cmake-masm
        CMAKE_ARGS
        -DAMD64=TRUE)
