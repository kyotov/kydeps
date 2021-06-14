include_guard(GLOBAL)

include(google/flags)

KyDepsInstall(glog
        GIT_REPOSITORY https://github.com/google/glog.git
        GIT_REF v0.4.0

        CMAKE_ARGS
        -DBUILD_TESTING=FALSE

        DEPENDS gflags)
