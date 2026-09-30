foreach(plugin IN ITEMS
    area
    collimated
    directional
    point
    constant
    envmap
    sun
    sunsky
    spot
)
    mitsuba_add_plugin(${plugin} "${CMAKE_CURRENT_SOURCE_DIR}/${plugin}.cpp")
endforeach()

mitsuba_add_plugin(sky "${CMAKE_CURRENT_SOURCE_DIR}/sky.cpp"
    "${CMAKE_CURRENT_SOURCE_DIR}/sunsky/skymodel.cpp")