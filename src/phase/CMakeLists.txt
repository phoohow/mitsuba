foreach(plugin IN ITEMS isotropic hg rayleigh kkay microflake mixturephase)
    mitsuba_add_plugin(${plugin} "${CMAKE_CURRENT_SOURCE_DIR}/${plugin}.cpp")
endforeach()