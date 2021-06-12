include_guard(GLOBAL)

KyDepsInstall(zlib
        GIT_REPOSITORY https://github.com/kyotov/zlib.git
        GIT_REF kyotov-fix

        CMAKE_ARGS
        -DAMD64=TRUE)
