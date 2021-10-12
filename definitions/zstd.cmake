include_guard(GLOBAL)

KyDepsInstall(zstd
        GIT_REPOSITORY https://github.com/facebook/zstd.git
        GIT_REF 645a2975c394dc115b57a652cf175cd4c2b59292 # v1.4.7

        SOURCE_SUBDIR build/cmake

        CMAKE_ARGS
        -DZSTD_BUILD_STATIC=TRUE
        -DZSTD_BUILD_SHARED=FALSE)
