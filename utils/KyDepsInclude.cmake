include_guard(GLOBAL)

function(KyDepsAdd)
    foreach (MODULE ${ARGN})
        include(${MODULE})
    endforeach ()
endfunction()
