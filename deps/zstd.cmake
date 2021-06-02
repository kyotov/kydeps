include_guard(GLOBAL)

KyDepsInstall(zstd
        https://github.com/facebook/zstd.git
        v1.4.7

        SOURCE_SUBDIR build/cmake

        CMAKE_ARGS
        -DZSTD_BUILD_STATIC=TRUE
        -DZSTD_BUILD_SHARED=FALSE)
