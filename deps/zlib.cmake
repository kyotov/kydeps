include_guard(GLOBAL)

KyDepsInstall(https://github.com/kyotov/zlib.git v1.2.11-fix-cmake-masm
        CMAKE_ARGS
        -DAMD64=TRUE)

# idea adapted from https://stackoverflow.com/questions/58347250/how-to-find-static-version-of-zlib-in-cmake
if (WIN32)
    if ("${CMAKE_BUILD_TYPE}" STREQUAL "Debug")
        set(D "d")
    endif ()

    ExternalProject_Add_Step(
            zlib zlib_remove_shared_objects
            COMMENT "remove shared objects"
            DEPENDEES install
            COMMAND ${CMAKE_COMMAND} -E rm -f <INSTALL_DIR>/install/bin/zlib${D}.dll
            COMMAND ${CMAKE_COMMAND} -E rename <INSTALL_DIR>/install/lib/zlibstatic${D}.lib <INSTALL_DIR>/install/lib/zlib${D}.lib)
else ()
#    ExternalProject_Add_Step(
#            zlib zlib_remove_shared_objects
#            COMMENT "remove shared objects"
#            DEPENDEES install
#            COMMAND ${CMAKE_COMMAND} -E rm -f <INSTALL_DIR>/install/lib/libz.so)
endif ()
