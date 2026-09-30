set(MITSUBA_BSDF_PLUGINS
    diffuse
    dielectric
    conductor
    plastic
    roughdiffuse
    roughdielectric
    roughconductor
    roughplastic
    twosided
    mask
    mixturebsdf
    blendbsdf
    coating
    roughcoating
    bumpmap
    normalmap
    ward
    phong
    difftrans
    hk
    null
    thindielectric
)

foreach(plugin IN LISTS MITSUBA_BSDF_PLUGINS)
    mitsuba_add_plugin(${plugin} "${CMAKE_CURRENT_SOURCE_DIR}/${plugin}.cpp")
endforeach()

if(MITSUBA_BUILD_IRAWAN)
    mitsuba_add_plugin(irawan "${CMAKE_CURRENT_SOURCE_DIR}/irawan.cpp")
endif()