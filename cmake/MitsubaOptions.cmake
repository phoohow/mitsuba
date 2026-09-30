include_guard(GLOBAL)

option(MITSUBA_BUILD_GUI "Build the Qt graphical interface when Qt is available" ON)
option(MITSUBA_BUILD_COLLADA "Build the COLLADA importer when COLLADA DOM is available" ON)
option(MITSUBA_BUILD_PYTHON "Build a Python 3 Boost.Python module" OFF)
option(MITSUBA_ENABLE_OPENMP "Enable OpenMP where available" ON)
option(MITSUBA_SINGLE_PRECISION "Use single-precision floating point" ON)
option(MITSUBA_ENABLE_SSE "Enable Mitsuba SSE code paths" ON)
option(MITSUBA_ENABLE_COHERENT_RT "Enable coherent ray tracing code paths" ON)
option(MITSUBA_DEBUG_CHECKS "Enable Mitsuba debug checks" ON)
set(MITSUBA_SPECTRUM_SAMPLES 3 CACHE STRING "Number of spectral samples")
set(MITSUBA_DEPENDENCIES_ROOT "${CMAKE_CURRENT_SOURCE_DIR}/dependencies" CACHE PATH
    "Path to the prebuilt third-party dependencies")

set(MITSUBA_BUILD_IRAWAN_DEFAULT ON)

if(MSVC AND MSVC_VERSION GREATER 1916)
    set(MITSUBA_BUILD_IRAWAN_DEFAULT OFF)
endif()

option(MITSUBA_BUILD_IRAWAN "Build the Irawan BSDF plugin" ${MITSUBA_BUILD_IRAWAN_DEFAULT})

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS ON)