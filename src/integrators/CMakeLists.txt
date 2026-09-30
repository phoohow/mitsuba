mitsuba_add_plugin(ao "${CMAKE_CURRENT_SOURCE_DIR}/direct/ao.cpp")
mitsuba_add_plugin(direct "${CMAKE_CURRENT_SOURCE_DIR}/direct/direct.cpp")
mitsuba_add_plugin(path "${CMAKE_CURRENT_SOURCE_DIR}/path/path.cpp")
mitsuba_add_plugin(volpath "${CMAKE_CURRENT_SOURCE_DIR}/path/volpath.cpp")
mitsuba_add_plugin(volpath_simple "${CMAKE_CURRENT_SOURCE_DIR}/path/volpath_simple.cpp")
mitsuba_add_plugin(ptracer "${CMAKE_CURRENT_SOURCE_DIR}/ptracer/ptracer.cpp"
    "${CMAKE_CURRENT_SOURCE_DIR}/ptracer/ptracer_proc.cpp")
mitsuba_add_plugin(photonmapper "${CMAKE_CURRENT_SOURCE_DIR}/photonmapper/photonmapper.cpp"
    "${CMAKE_CURRENT_SOURCE_DIR}/photonmapper/bre.cpp")

foreach(plugin IN ITEMS ppm sppm)
    mitsuba_add_plugin(${plugin} "${CMAKE_CURRENT_SOURCE_DIR}/photonmapper/${plugin}.cpp")
endforeach()

mitsuba_add_plugin(vpl "${CMAKE_CURRENT_SOURCE_DIR}/vpl/vpl.cpp")

foreach(plugin IN ITEMS adaptive multichannel field motion)
    mitsuba_add_plugin(${plugin} "${CMAKE_CURRENT_SOURCE_DIR}/misc/${plugin}.cpp")
endforeach()

mitsuba_add_plugin(irrcache "${CMAKE_CURRENT_SOURCE_DIR}/misc/irrcache.cpp"
    "${CMAKE_CURRENT_SOURCE_DIR}/misc/irrcache_proc.cpp")

mitsuba_add_plugin(bdpt "${CMAKE_CURRENT_SOURCE_DIR}/bdpt/bdpt.cpp"
    "${CMAKE_CURRENT_SOURCE_DIR}/bdpt/bdpt_wr.cpp" "${CMAKE_CURRENT_SOURCE_DIR}/bdpt/bdpt_proc.cpp")
mitsuba_add_plugin(pssmlt "${CMAKE_CURRENT_SOURCE_DIR}/pssmlt/pssmlt.cpp"
    "${CMAKE_CURRENT_SOURCE_DIR}/pssmlt/pssmlt_sampler.cpp" "${CMAKE_CURRENT_SOURCE_DIR}/pssmlt/pssmlt_proc.cpp")
mitsuba_add_plugin(mlt "${CMAKE_CURRENT_SOURCE_DIR}/mlt/mlt.cpp"
    "${CMAKE_CURRENT_SOURCE_DIR}/mlt/mlt_proc.cpp")
mitsuba_add_plugin(erpt "${CMAKE_CURRENT_SOURCE_DIR}/erpt/erpt.cpp"
    "${CMAKE_CURRENT_SOURCE_DIR}/erpt/erpt_proc.cpp")