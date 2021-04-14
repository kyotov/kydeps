include_guard(GLOBAL)

KyDepsInstall(https://github.com/kyotov/zlib.git v1.2.11-fix-cmake-masm
        CMAKE_ARGS
        -DAMD64=TRUE)

#STRING(TOUPPER "${CMAKE_BUILD_TYPE}" CMAKE_BUILD_TYPE_TOUPPER)
#
#set(KYDEPS_C_FLAGS
#        ${CMAKE_C_FLAGS}
#        ${CMAKE_C_FLAGS_${CMAKE_BUILD_TYPE_TOUPPER}}
#        ${KYDEPS_COMPILE_OPTIONS})
#list(JOIN KYDEPS_C_FLAGS " " KYDEPS_C_FLAGS)
#message(NOTICE "${CMAKE_CURRENT_LIST_FILE}: Using KYDEPS_C_FLAGS = ${KYDEPS_C_FLAGS}")
#
#get_property(CMAKE_LINK_OPTIONS DIRECTORY PROPERTY LINK_OPTIONS)
#set(KYDEPS_EXE_LINKER_FLAGS
#        ${CMAKE_EXE_LINKER_FLAGS}
#        ${CMAKE_EXE_LINKER_FLAGS_${CMAKE_BUILD_TYPE_TOUPPER}}
#        ${KYDEPS_LINK_OPTIONS})
#list(JOIN KYDEPS_EXE_LINKER_FLAGS " " KYDEPS_EXE_LINKER_FLAGS)
#message(NOTICE "${CMAKE_CURRENT_LIST_FILE}: Using KYDEPS_EXE_LINKER_FLAGS = ${KYDEPS_EXE_LINKER_FLAGS}")
#
#if (WIN32)
#
#    file(WRITE ${CMAKE_BINARY_DIR}/zlib.nmake
#            AS=ml64\n
#            LOC="-DASMV -DASMINF -DNDEBUG -I."\n
#            OBJA="inffasx64.obj gvmat64.obj inffas8664.obj"\n
#            EXTRA_CFLAGS="${KYDEPS_C_FLAGS}"\n
#            EXTRA_LDFLAGS="${KYDEPS_EXE_LINKER_FLAGS}"\n
#            -f win32/Makefile.msc\n
#            zlib.lib\n)
#
#    # with inspiration from https://stackoverflow.com/a/41815728/4720732
#
#    if (CMAKE_BUILD_TYPE STREQUAL "Debug")
#        set(COPY_PDB
#                COMMAND ${CMAKE_COMMAND} -E copy_if_different <SOURCE_DIR>/zlib.pdb <INSTALL_DIR>/install/lib/zlib.pdb)
#    endif ()
#
#    InstallDependency_Git(https://github.com/kyotov/zlib.git v1.2.11-with-extra-flags
#            CONFIGURE_COMMAND ""
#            BUILD_COMMAND ${CMAKE_COMMAND} -E chdir <SOURCE_DIR> nmake @${CMAKE_BINARY_DIR}/zlib.nmake
#            INSTALL_COMMAND ${CMAKE_COMMAND} -E copy_if_different <SOURCE_DIR>/zlib.h <INSTALL_DIR>/install/include/zlib.h
#            COMMAND ${CMAKE_COMMAND} -E copy_if_different <SOURCE_DIR>/zconf.h <INSTALL_DIR>/install/include/zconf.h
#            COMMAND ${CMAKE_COMMAND} -E copy_if_different <SOURCE_DIR>/zlib.lib <INSTALL_DIR>/install/lib/zlib.lib
#            ${COPY_PDB})
#
#endif ()
