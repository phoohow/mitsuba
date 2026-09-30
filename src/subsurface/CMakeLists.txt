mitsuba_add_plugin(dipole "${CMAKE_CURRENT_SOURCE_DIR}/dipole.cpp"
    "${CMAKE_CURRENT_SOURCE_DIR}/irrproc.cpp" "${CMAKE_CURRENT_SOURCE_DIR}/irrtree.cpp"
    "${CMAKE_CURRENT_SOURCE_DIR}/bluenoise.cpp")
mitsuba_add_plugin(singlescatter "${CMAKE_CURRENT_SOURCE_DIR}/singlescatter.cpp")