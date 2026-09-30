foreach(plugin IN ITEMS
    radiancemeter
    irradiancemeter
    fluencemeter
    perspective
    perspective_rdist
    thinlens
    orthographic
    telecentric
    spherical
)
    mitsuba_add_plugin(${plugin} "${CMAKE_CURRENT_SOURCE_DIR}/${plugin}.cpp")
endforeach()