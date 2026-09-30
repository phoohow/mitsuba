if(NOT MITSUBA_BUILD_PYTHON)
    return()
endif()

find_package(Python3 REQUIRED COMPONENTS Development.Module)
set(BOOST_PYTHON_COMPONENT "python${Python3_VERSION_MAJOR}${Python3_VERSION_MINOR}")
find_package(Boost REQUIRED MODULE COMPONENTS ${BOOST_PYTHON_COMPONENT})
add_library(mitsuba-python MODULE core.cpp render.cpp)
target_compile_definitions(mitsuba-python PRIVATE MTS_BUILD_MODULE=5)

if(NOT MSVC)
    target_compile_options(mitsuba-python PRIVATE -fno-strict-aliasing)
endif()

target_link_libraries(mitsuba-python PRIVATE
    mitsuba-bidir mitsuba-render mitsuba-core mitsuba-common
    Python3::Module Boost::${BOOST_PYTHON_COMPONENT})
set_target_properties(mitsuba-python PROPERTIES
    PREFIX ""
    OUTPUT_NAME mitsuba
    LIBRARY_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/python")
install(TARGETS mitsuba-python
    LIBRARY DESTINATION "python/${Python3_VERSION_MAJOR}.${Python3_VERSION_MINOR}")