include_guard(GLOBAL)

KyDepsInstall(zlib
        https://github.com/kyotov/zlib.git
        kyotov-fix

        CMAKE_ARGS
        -DAMD64=TRUE)
