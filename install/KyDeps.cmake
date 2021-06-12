include_guard(GLOBAL)

function(init)
    set(KYDEPS_INSTALL_ROOT_PATH ${CMAKE_CURRENT_FUNCTION_LIST_DIR} PARENT_SCOPE)
endfunction()

init()

list(APPEND CMAKE_MODULE_PATH "${KYDEPS_INSTALL_ROOT_PATH}")

include(KyDepsPopulate)
