include_guard(GLOBAL)

function(mitsuba_set_output_dirs target)
    set_target_properties(${target} PROPERTIES
        ARCHIVE_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/lib"
        LIBRARY_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/lib"
        RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bin"
        CXX_VISIBILITY_PRESET hidden
        VISIBILITY_INLINES_HIDDEN YES)

    if(WIN32 AND MITSUBA_RUNTIME_DLLS)
        # Copy the third-party runtime DLLs next to the target so that the
        # build-tree executables can be run directly. Using a generator
        # expression handles multi-config generators (e.g. Visual Studio),
        # which append a per-configuration subdirectory to the output path.
        add_custom_command(TARGET ${target} POST_BUILD
            COMMAND ${CMAKE_COMMAND} -E copy_if_different
            ${MITSUBA_RUNTIME_DLLS} $<TARGET_FILE_DIR:${target}>)
    endif()
endfunction()

function(mitsuba_add_plugin name)
    set(target "mitsuba-plugin-${name}")
    add_library(${target} MODULE ${ARGN})
    target_link_libraries(${target} PRIVATE mitsuba-core mitsuba-render mitsuba-hw mitsuba-bidir mitsuba-common)

    # Place the plugins in a "plugins" subdirectory next to mitsuba-core.dll,
    # which is where the PluginManager looks for them at runtime. Using a
    # generator expression keeps the path correct for multi-config generators
    # (e.g. Visual Studio appends a per-configuration subdirectory otherwise).
    set_target_properties(${target} PROPERTIES
        PREFIX ""
        OUTPUT_NAME "${name}"
        LIBRARY_OUTPUT_DIRECTORY "$<TARGET_FILE_DIR:mitsuba-core>/plugins"
        RUNTIME_OUTPUT_DIRECTORY "$<TARGET_FILE_DIR:mitsuba-core>/plugins"
        CXX_VISIBILITY_PRESET hidden
        VISIBILITY_INLINES_HIDDEN YES)
    install(TARGETS ${target} LIBRARY DESTINATION plugins RUNTIME DESTINATION plugins)
endfunction()

function(mitsuba_add_application target source)
    set(sources "${source}")

    if(WIN32)
        list(APPEND sources "${CMAKE_SOURCE_DIR}/data/windows/wmain_stub.cpp")
    elseif(APPLE)
        list(APPEND sources "${CMAKE_SOURCE_DIR}/src/mitsuba/darwin_stub.mm")
    endif()

    add_executable(${target} ${sources})
    target_link_libraries(${target} PRIVATE mitsuba-core mitsuba-render mitsuba-hw mitsuba-common)
    mitsuba_set_output_dirs(${target})
    install(TARGETS ${target} RUNTIME DESTINATION .)
endfunction()