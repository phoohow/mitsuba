file(GLOB MITSUBA_TEST_SOURCES CONFIGURE_DEPENDS "${CMAKE_CURRENT_SOURCE_DIR}/test_*.cpp")

foreach(source IN LISTS MITSUBA_TEST_SOURCES)
    get_filename_component(name "${source}" NAME_WE)
    mitsuba_add_plugin(${name} "${source}")
    target_compile_definitions("mitsuba-plugin-${name}" PRIVATE MTS_TESTCASE=1)
endforeach()