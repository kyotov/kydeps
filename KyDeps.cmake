include_guard(GLOBAL)

#
# set the module path for easy include(...)
#
# TODO: make sure this works across projects... probably will need something else than CMAKE_SOURCE_DIR
#
list(APPEND CMAKE_MODULE_PATH
        ${CMAKE_CURRENT_LIST_DIR}
        ${CMAKE_CURRENT_LIST_DIR}/utils
        ${CMAKE_CURRENT_LIST_DIR}/deps)

include(KyDepsPrologue)
include(KyDepsOptions)
include(KyDepsInstall)
include(KyDepsPackage)
include(KyDepsInclude)
include(KyDepsEpilogue)
