foreach(plugin IN ITEMS box tent lanczos mitchell catmullrom gaussian)
    mitsuba_add_plugin(${plugin} "${CMAKE_CURRENT_SOURCE_DIR}/${plugin}.cpp")
endforeach()