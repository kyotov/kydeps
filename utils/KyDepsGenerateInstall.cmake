message(STATUS "KyDeps Install Generator")

function(main)

    include(${CONFIG})

    foreach (PACKAGE_NAME ${KYDEPS_PACKAGE_NAMES})

        foreach (VAR MANIFEST HASH FIND_PACKAGE_OPTIONS)
            set(X_${VAR} ${${PACKAGE_NAME}_${VAR}})
        endforeach ()

        if ("${X_FIND_PACKAGE_OPTIONS}" STREQUAL "")
            set(X_FIND_PACKAGE_OPTIONS NO_MODULE)
        endif ()

        set(X_DEPENDS)
        foreach (DEP ${${PACKAGE_NAME}_DEPENDS})
            string(APPEND X_DEPENDS "\ninclude(${DEP})")
        endforeach ()

        string(TOLOWER "${PACKAGE_NAME}" X_CONTENT)

        set(X_LOCAL_PACKAGE_PATH "${${PACKAGE_NAME}_ROOT_PATH}/package.zip")
        set(X_URL "file://${X_LOCAL_PACKAGE_PATH}")

        file(SHA1 "${X_LOCAL_PACKAGE_PATH}" X_SHA1)

        configure_file(
                ${CMAKE_CURRENT_FUNCTION_LIST_DIR}/templates/package_redirect.cmake.in
                ${KYDEPS_TARGET_DIR}/${PACKAGE_NAME}.cmake
                @ONLY)

        configure_file(
                ${CMAKE_CURRENT_FUNCTION_LIST_DIR}/templates/package_definition.cmake.in
                ${KYDEPS_TARGET_SUBDIR}/${PACKAGE_NAME}.cmake
                @ONLY)
    endforeach ()

endfunction()

main()
