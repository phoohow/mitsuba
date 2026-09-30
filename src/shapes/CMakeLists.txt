foreach(plugin IN ITEMS
    obj
    serialized
    rectangle
    disk
    sphere
    cylinder
    hair
    shapegroup
    instance
    cube
    heightfield
)
    mitsuba_add_plugin(${plugin} "${CMAKE_CURRENT_SOURCE_DIR}/${plugin}.cpp")
endforeach()

mitsuba_add_plugin(ply "${CMAKE_CURRENT_SOURCE_DIR}/ply.cpp"
    "${CMAKE_CURRENT_SOURCE_DIR}/ply/ply_parser.cpp")
target_include_directories(mitsuba-plugin-ply PRIVATE "${CMAKE_CURRENT_SOURCE_DIR}")