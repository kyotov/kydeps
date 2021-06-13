function(main)
    include(${CONFIG})
    message(STATUS "KyDeps Install Generator : ${KYDEPS_NAME}")

    set(DEPENDS)
    foreach (DEP ${KYDEPS_DEPENDS})
        string(APPEND DEPENDS "\ninclude(${DEP})")
    endforeach ()

    if ("${KYDEPS_BUILD_TYPE_OVERRIDE}" STREQUAL "")
        set(KYDEPS_BUILD_TYPE_OVERRIDE [[${CMAKE_BUILD_TYPE}]])
    endif ()

    if ("${KYDEPS_FIND_OVERRIDE}" STREQUAL "")
        set(KYDEPS_FIND_OVERRIDE "find_package(${KYDEPS_NAME} REQUIRED NO_MODULE)")
    endif ()

    file(SHA1 "${KYDEPS_ROOT_PATH}/package.zip" SHA1)

    configure_file(
            ${CMAKE_CURRENT_FUNCTION_LIST_DIR}/templates/package_redirect.cmake.in
            ${KYDEPS_DIR}/${KYDEPS_NAME}.cmake
            @ONLY)

    configure_file(
            ${CMAKE_CURRENT_FUNCTION_LIST_DIR}/templates/package_definition.cmake.in
            ${KYDEPS_DIR}/${KYDEPS_SUBDIR}/${KYDEPS_NAME}.cmake
            @ONLY)

endfunction()

main()
