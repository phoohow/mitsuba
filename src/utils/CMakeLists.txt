foreach(plugin IN ITEMS
    addimages
    joinrgb
    cylclip
    kdbench
    tonemap
)
    mitsuba_add_plugin(${plugin} "${CMAKE_CURRENT_SOURCE_DIR}/${plugin}.cpp")
endforeach()