include_guard(GLOBAL)

include(FetchContent)

function(KyDepsPopulate PACKAGE_NAME PACKAGE_HASH PACKAGE_URL PACKAGE_URL_HASH)

    FetchContent_Declare(${PACKAGE_HASH}
            URL ${PACKAGE_URL}
            URL_HASH SHA1=${PACKAGE_URL_HASH}
            SOURCE_DIR ".deps/${PACKAGE_NAME}"
            BINARY_DIR ".deps/${PACKAGE_NAME}"
            SUBBUILD_DIR ".fetch/${PACKAGE_NAME}")

    if(NOT ${PACKAGE_HASH}_POPULATED)
        FetchContent_Populate(${PACKAGE_HASH})
    endif()

endfunction()
