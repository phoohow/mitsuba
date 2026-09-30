foreach(plugin IN ITEMS independent stratified ldsampler)
    mitsuba_add_plugin(${plugin} "${CMAKE_CURRENT_SOURCE_DIR}/${plugin}.cpp")
endforeach()

mitsuba_add_plugin(halton "${CMAKE_CURRENT_SOURCE_DIR}/halton.cpp" "${CMAKE_CURRENT_SOURCE_DIR}/faure.cpp")
mitsuba_add_plugin(hammersley "${CMAKE_CURRENT_SOURCE_DIR}/hammersley.cpp" "${CMAKE_CURRENT_SOURCE_DIR}/faure.cpp")
mitsuba_add_plugin(sobol "${CMAKE_CURRENT_SOURCE_DIR}/sobol.cpp" "${CMAKE_CURRENT_SOURCE_DIR}/sobolseq.cpp")