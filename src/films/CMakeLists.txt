foreach(plugin IN ITEMS ldrfilm hdrfilm)
    mitsuba_add_plugin(${plugin} "${CMAKE_CURRENT_SOURCE_DIR}/${plugin}.cpp")
endforeach()

mitsuba_add_plugin(mfilm "${CMAKE_CURRENT_SOURCE_DIR}/mfilm.cpp" "${CMAKE_CURRENT_SOURCE_DIR}/cnpy.cpp")

if(OpenEXR_FOUND)
    mitsuba_add_plugin(tiledhdrfilm "${CMAKE_CURRENT_SOURCE_DIR}/tiledhdrfilm.cpp")
endif()