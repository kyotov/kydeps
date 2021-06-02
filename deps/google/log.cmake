include_guard(GLOBAL)

include(google/flags)

KyDepsInstall(glog
        https://github.com/google/glog.git
        v0.4.0

        CMAKE_ARGS
        -DBUILD_TESTING=FALSE

        DEPENDS gflags)
