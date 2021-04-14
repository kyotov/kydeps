include_guard(GLOBAL)

KyDepsInstall(
        https://github.com/gflags/gflags.git
        v2.2.0

        CMAKE_ARGS
        -DREGISTER_INSTALL_PREFIX=FALSE
        -DGFLAGS_BUILD_STATIC_LIBS=TRUE
        -DGFLAGS_BUILD_SHARED_LIBS=FALSE
        -DGFLAGS_BUILD_TESTING=FALSE)
