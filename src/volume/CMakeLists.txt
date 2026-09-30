foreach(plugin IN ITEMS
    constvolume
    gridvolume
    hgridvolume
    volcache
)
    mitsuba_add_plugin(${plugin} "${CMAKE_CURRENT_SOURCE_DIR}/${plugin}.cpp")
endforeach()