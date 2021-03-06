include_guard(GLOBAL)

set(Boost_DISABLE_GIT_CACHE TRUE)

math(EXPR Boost_ADDRESS_MODEL "8 * ${CMAKE_SIZEOF_VOID_P}")

string(TOLOWER "${CMAKE_BUILD_TYPE}" Boost_VARIANT)

set(Boost_CONFIG
        --build-dir=<BINARY_DIR>/build
        --stagedir=<BINARY_DIR>/stage
        --prefix=<INSTALL_DIR>

        --layout=system

        --without-graph_parallel
        --without-mpi
        --without-python

        variant=${Boost_VARIANT}
        link=static
        runtime-link=static
        threading=multi
        address-model=${Boost_ADDRESS_MODEL})

set(Boost_FIND_OVERRIDE [[
    set(Boost_USE_STATIC_RUNTIME ON)
    find_package(Boost 1.76.0 REQUIRED COMPONENTS ALL NO_MODULE)
]])

set(Boost_Windows_BOOTSTRAP cmd /c "<SOURCE_DIR>/bootstrap.bat")
if (DEFINED Boost_${CMAKE_SYSTEM_NAME}_BOOTSTRAP)
    set(Boost_BOOTSTRAP ${Boost_${CMAKE_SYSTEM_NAME}_BOOTSTRAP})
else ()
    set(Boost_BOOTSTRAP ./bootstrap.sh)
endif ()

KyDepsInstall(Boost
        GIT_REPOSITORY https://github.com/boostorg/boost.git
        GIT_REF ccb2ab3b4384a16deafaa849de509bce2b2cbada # boost-1.76.0

        CONFIGURE_COMMAND ${CMAKE_COMMAND} -E chdir <SOURCE_DIR> ${Boost_BOOTSTRAP}
        BUILD_COMMAND ${CMAKE_COMMAND} -E echo "skipped"
        INSTALL_COMMAND ${CMAKE_COMMAND} -E chdir <SOURCE_DIR> "<SOURCE_DIR>/b2" ${Boost_CONFIG} install)
