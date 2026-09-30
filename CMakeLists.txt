cmake_minimum_required(VERSION 3.16)

project(Mitsuba VERSION 0.6.0 LANGUAGES C CXX)

if(POLICY CMP0167)
    cmake_policy(SET CMP0167 OLD)
endif()

include(GNUInstallDirs)
include(cmake/MitsubaOptions.cmake)
include(cmake/MitsubaDependencies.cmake)
include(cmake/MitsubaTargets.cmake)

if(APPLE)
    enable_language(OBJCXX)
endif()

add_subdirectory(src/libcore)
add_subdirectory(src/librender)
add_subdirectory(src/libhw)
add_subdirectory(src/libbidir)

add_subdirectory(src/mitsuba)
add_subdirectory(src/converter)
add_subdirectory(src/mtsgui)
add_subdirectory(src/libpython)

add_subdirectory(src/utils)
add_subdirectory(src/bsdfs)
add_subdirectory(src/phase)
add_subdirectory(src/shapes)
add_subdirectory(src/samplers)
add_subdirectory(src/rfilters)
add_subdirectory(src/films)
add_subdirectory(src/sensors)
add_subdirectory(src/emitters)
add_subdirectory(src/medium)
add_subdirectory(src/volume)
add_subdirectory(src/subsurface)
add_subdirectory(src/textures)
add_subdirectory(src/integrators)
add_subdirectory(src/tests)

install(TARGETS mitsuba-core mitsuba-render mitsuba-hw mitsuba-bidir
    RUNTIME DESTINATION .
    LIBRARY DESTINATION .
    ARCHIVE DESTINATION "${CMAKE_INSTALL_LIBDIR}")

# install(DIRECTORY include/
# DESTINATION include)
install(DIRECTORY data/schema/
    DESTINATION data/schema FILES_MATCHING PATTERN "*.xsd" PATTERN "*.xsl")
install(DIRECTORY data/ior/
    DESTINATION data/ior FILES_MATCHING PATTERN "*.spd")
install(DIRECTORY data/microfacet/
    DESTINATION data/microfacet FILES_MATCHING PATTERN "*.dat")

if(WIN32)
    # Install the third-party runtime DLLs (bundled dependencies and Boost)
    # listed in MITSUBA_RUNTIME_DLLS. Using install(FILES) instead of
    # install(DIRECTORY) avoids copying unrelated files such as import
    # libraries (.lib) or Boost's CMake package directories.
    install(FILES ${MITSUBA_RUNTIME_DLLS} DESTINATION .)
endif()

if(WIN32)
    install(FILES data/windows/README.txt DESTINATION .)
endif()

set(CPACK_PACKAGE_NAME "mitsuba")
set(CPACK_PACKAGE_VERSION "${PROJECT_VERSION}")

if(WIN32)
    set(CPACK_GENERATOR ZIP)
elseif(APPLE)
    set(CPACK_GENERATOR DragNDrop)
else()
    set(CPACK_GENERATOR TGZ)
endif()

include(CPack)