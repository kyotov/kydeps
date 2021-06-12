include_guard(GLOBAL)

include(FetchContent)

function(KyDepsPopulate PACKAGE_NAME PACKAGE_URL PACKAGE_URL_HASH)

    string(TOLOWER "${PACKAGE_NAME}" LC_PACKAGE_NAME)

    FetchContent_Declare(${LC_PACKAGE_NAME}
            URL ${PACKAGE_URL}
            URL_HASH SHA1=${PACKAGE_URL_HASH}
            SOURCE_DIR ".deps/${LC_PACKAGE_NAME}"
            BINARY_DIR ".deps/${LC_PACKAGE_NAME}"
            SUBBUILD_DIR ".populators/${LC_PACKAGE_NAME}")

    if(NOT ${LC_PACKAGE_NAME}_POPULATED)
        FetchContent_Populate(${LC_PACKAGE_NAME})
    endif()

endfunction()
