include_guard(GLOBAL)

include(zlib)

IF (WIN32)
    # based on https://stackoverflow.com/a/41815728/4720732

    ExternalProject_Add(
            perl
            URL https://strawberryperl.com/download/5.32.1.1/strawberry-perl-5.32.1.1-64bit-portable.zip
            PREFIX ${CMAKE_BINARY_DIR}

            USES_TERMINAL_DOWNLOAD TRUE

            CONFIGURE_COMMAND ""
            BUILD_COMMAND ""
            INSTALL_COMMAND ""
    )

    KyDepsInstallGit(https://github.com/openssl/openssl.git OpenSSL_1_1_1k
            DEPENDS perl zlib

            USES_TERMINAL_BUILD TRUE
            USES_TERMINAL_INSTALL TRUE

            # TODO: figure out if we can't put some include directory...
            PATCH_COMMAND ${CMAKE_COMMAND} -E copy_if_different <INSTALL_DIR>/install/include/zlib.h <SOURCE_DIR>/zlib.h
            COMMAND ${CMAKE_COMMAND} -E copy_if_different <INSTALL_DIR>/install/include/zconf.h <SOURCE_DIR>/zconf.h

            CONFIGURE_COMMAND ${CMAKE_COMMAND} -E chdir <SOURCE_DIR> <INSTALL_DIR>/src/perl/perl/bin/perl Configure VC-WIN64A-masm zlib no-shared no-zlib-dynamic threads --prefix=<INSTALL_DIR>/install --openssldir=<INSTALL_DIR>/install -MT

            # NOTE: this used to be necessary when building any linked artifacts (shared libraries, executables, etc.)
            #       because we only build static libraries, it is not needed anymore!
            # COMMAND ${CMAKE_COMMAND} -E chdir <SOURCE_DIR> <INSTALL_DIR>/src/perl/perl/bin/perl -pi.orig -e s/ZLIB1/zlib.lib/g; makefile

            BUILD_COMMAND ${CMAKE_COMMAND} -E chdir <SOURCE_DIR> nmake build_libs
            INSTALL_COMMAND ${CMAKE_COMMAND} -E chdir <SOURCE_DIR> nmake install_dev)
ELSE ()
    KyDepsInstallGit(https://github.com/openssl/openssl.git OpenSSL_1_1_1k
            CONFIGURE_COMMAND ${CMAKE_COMMAND} -E chdir <SOURCE_DIR> ./config no-shared no-dso --prefix=<INSTALL_DIR>/install --openssldir=<INSTALL_DIR>/install
            BUILD_COMMAND make -C <SOURCE_DIR> build_libs
            INSTALL_COMMAND make -C <SOURCE_DIR> install_dev)
ENDIF ()
