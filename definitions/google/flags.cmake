include_guard(GLOBAL)

KyDepsInstall(gflags
        GIT_REPOSITORY https://github.com/gflags/gflags.git
        GIT_REF v2.2.0

        CMAKE_ARGS
        -DREGISTER_INSTALL_PREFIX=FALSE
        -DGFLAGS_BUILD_STATIC_LIBS=TRUE
        -DGFLAGS_BUILD_SHARED_LIBS=FALSE
        -DGFLAGS_BUILD_TESTING=FALSE)
