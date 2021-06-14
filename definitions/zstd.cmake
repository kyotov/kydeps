include_guard(GLOBAL)

KyDepsInstall(zstd
        GIT_REPOSITORY https://github.com/facebook/zstd.git
        GIT_REF v1.4.7

        SOURCE_SUBDIR build/cmake

        CMAKE_ARGS
        -DZSTD_BUILD_STATIC=TRUE
        -DZSTD_BUILD_SHARED=FALSE)
