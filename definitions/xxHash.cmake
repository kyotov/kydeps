include_guard(GLOBAL)

KyDepsInstall(xxHash
        GIT_REPOSITORY https://github.com/Cyan4973/xxHash.git
        GIT_REF 94e5f23e736f2bb67ebdf90727353e65344f9fc0 # v0.8.0

        SOURCE_SUBDIR cmake_unofficial

        CMAKE_ARGS
        -DXXHASH_BUILD_XXHSUM=FALSE)
