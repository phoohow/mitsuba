if(NOT MITSUBA_BUILD_COLLADA)
    return()
endif()

find_path(COLLADA_DOM_INCLUDE_DIR dae.h
    PATH_SUFFIXES collada-dom2.4 collada-dom2.4/1.4 collada-dom)
find_library(COLLADA_DOM_LIBRARY NAMES collada-dom2.4-dp collada14dom24 collada-dom)

if(NOT COLLADA_DOM_INCLUDE_DIR OR NOT COLLADA_DOM_LIBRARY)
    message(STATUS "COLLADA DOM not found; the COLLADA importer is disabled")
    return()
endif()

target_compile_definitions(mitsuba-common INTERFACE MTS_HAS_COLLADA=1)
add_library(mitsuba-converter STATIC
    collada.cpp
    obj.cpp
    converter.cpp
)
target_include_directories(mitsuba-converter PRIVATE "${COLLADA_DOM_INCLUDE_DIR}")
target_compile_definitions(mitsuba-converter PRIVATE COLLADA_DOM_2_4)
target_link_libraries(mitsuba-converter PUBLIC
    mitsuba-core mitsuba-render mitsuba-hw mitsuba-common "${COLLADA_DOM_LIBRARY}")
mitsuba_set_output_dirs(mitsuba-converter)

mitsuba_add_application(mtsimport "${CMAKE_CURRENT_SOURCE_DIR}/mtsimport.cpp")
target_link_libraries(mtsimport PRIVATE mitsuba-converter "${COLLADA_DOM_LIBRARY}")