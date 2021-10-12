include_guard(GLOBAL)

include(google/flags)

KyDepsInstall(glog
        GIT_REPOSITORY https://github.com/google/glog.git
        GIT_REF 96a2f23dca4cc7180821ca5f32e526314395d26a # v0.4.0

        CMAKE_ARGS
        -DBUILD_TESTING=FALSE

        DEPENDS gflags)
