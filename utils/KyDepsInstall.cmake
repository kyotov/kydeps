include_guard(GLOBAL)

include(ExternalProject)

function(KyDepsInstallBase)
    get_filename_component(MODULE_NAME "${CMAKE_CURRENT_LIST_FILE}" NAME_WE)

    message(NOTICE ">>>>> ${MODULE_NAME}")
    # message(NOTICE ">>>>> \t ${CMAKE_CURRENT_LIST_FILE}")

    ExternalProject_Add(
            ${MODULE_NAME}
            PREFIX ${CMAKE_BINARY_DIR}
            ${ARGN}
    )
endfunction()

function(KyDepsInstallGit GIT_REPO GIT_REF)
    KyDepsInstallBase(
            GIT_REPOSITORY ${GIT_REPO}
            GIT_TAG ${GIT_REF}
            ${ARGN})

    message(NOTICE ">>>>> \t ${GIT_REF} @ ${GIT_REPO}")
endfunction()

function(KyDepsInstall GIT_REPO GIT_REF)
    KyDepsInstallGit(${GIT_REPO} ${GIT_REF}
            CMAKE_ARGS
            # TODO: we used to have this, but it suddenly started erroring in GitHub CI version of cmake...
            # --config ${CMAKE_BUILD_TYPE}
            -DCMAKE_INSTALL_PREFIX:PATH=${CMAKE_BINARY_DIR}/install
            -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
            -DCMAKE_MSVC_RUNTIME_LIBRARY=${CMAKE_MSVC_RUNTIME_LIBRARY}
            -DCMAKE_POLICY_DEFAULT_CMP0091=NEW
            -DBUILD_SHARED_LIBS=FALSE
            ${ARGN})
endfunction()
