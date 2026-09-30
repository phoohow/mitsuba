foreach(plugin IN ITEMS
    bitmap
    scale
    gridtexture
    checkerboard
    vertexcolors
    wireframe
    curvature
)
    mitsuba_add_plugin(${plugin} "${CMAKE_CURRENT_SOURCE_DIR}/${plugin}.cpp")
endforeach()