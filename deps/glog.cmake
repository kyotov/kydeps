include_guard(GLOBAL)

include(gflags)

KyDepsInstall(glog
        https://github.com/google/glog.git
        v0.4.0

        DEPENDS gflags

        CMAKE_ARGS
        -DBUILD_TESTING=FALSE)
