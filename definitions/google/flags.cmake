include_guard(GLOBAL)

KyDepsInstall(gflags
        GIT_REPOSITORY https://github.com/gflags/gflags.git
        GIT_REF f8a0efe03aa69b3336d8e228b37d4ccb17324b88 # v2.2.0

        CMAKE_ARGS
        -DREGISTER_INSTALL_PREFIX=FALSE
        -DGFLAGS_BUILD_STATIC_LIBS=TRUE
        -DGFLAGS_BUILD_SHARED_LIBS=FALSE
        -DGFLAGS_BUILD_TESTING=FALSE)
