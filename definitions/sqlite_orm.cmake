include_guard(GLOBAL)

include(sqlite3)

kydepsinstall(SqliteOrm
        GIT_REPOSITORY https://github.com/fnc12/sqlite_orm.git
        GIT_REF 4c6a46bd4dcfba14a650e0fafb86331526878587 # 1.6

        CMAKE_ARGS
        -DSQLITE_ORM_ENABLE_CXX_17=ON
        -DBUILD_TESTING=OFF # maybe a problem with "master" not being there in catch2 repo anymore?

        DEPENDS
        SQLite3)
