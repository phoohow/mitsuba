include_guard(GLOBAL)

find_package(OpenGL REQUIRED)

find_package(Boost 1.80 REQUIRED MODULE COMPONENTS filesystem thread chrono atomic)

if(NOT TARGET Boost::system)
    add_library(Boost::system INTERFACE IMPORTED)
    set_target_properties(Boost::system PROPERTIES
        INTERFACE_INCLUDE_DIRECTORIES "${Boost_INCLUDE_DIRS}")
endif()

set(MITSUBA_USE_BUNDLED_DEPENDENCIES TRUE)

if(MITSUBA_USE_BUNDLED_DEPENDENCIES)
    set(MITSUBA_DEPENDENCY_INCLUDE_DIR "${MITSUBA_DEPENDENCIES_ROOT}/include")
    set(MITSUBA_DEPENDENCY_LIBRARY_DIR "${MITSUBA_DEPENDENCIES_ROOT}/lib")

    add_library(XercesC::XercesC UNKNOWN IMPORTED)
    set_target_properties(XercesC::XercesC PROPERTIES
        IMPORTED_LOCATION "${MITSUBA_DEPENDENCY_LIBRARY_DIR}/xerces-c_3.lib"
        INTERFACE_INCLUDE_DIRECTORIES "${MITSUBA_DEPENDENCY_INCLUDE_DIR}")

    add_library(Eigen3::Eigen INTERFACE IMPORTED)
    set_target_properties(Eigen3::Eigen PROPERTIES
        INTERFACE_INCLUDE_DIRECTORIES "${MITSUBA_DEPENDENCY_INCLUDE_DIR}")

    add_library(GLEW::GLEW UNKNOWN IMPORTED)
    set_target_properties(GLEW::GLEW PROPERTIES
        IMPORTED_LOCATION "${MITSUBA_DEPENDENCY_LIBRARY_DIR}/glew32mx.lib"
        INTERFACE_INCLUDE_DIRECTORIES "${MITSUBA_DEPENDENCY_INCLUDE_DIR}")

    add_library(ZLIB::ZLIB UNKNOWN IMPORTED)
    set_target_properties(ZLIB::ZLIB PROPERTIES
        IMPORTED_LOCATION "${MITSUBA_DEPENDENCY_LIBRARY_DIR}/zlib.lib"
        INTERFACE_INCLUDE_DIRECTORIES "${MITSUBA_DEPENDENCY_INCLUDE_DIR}")

    add_library(PNG::PNG UNKNOWN IMPORTED)
    set_target_properties(PNG::PNG PROPERTIES
        IMPORTED_LOCATION "${MITSUBA_DEPENDENCY_LIBRARY_DIR}/libpng16.lib"
        INTERFACE_INCLUDE_DIRECTORIES "${MITSUBA_DEPENDENCY_INCLUDE_DIR}"
        INTERFACE_LINK_LIBRARIES ZLIB::ZLIB)
    set(PNG_FOUND TRUE)

    add_library(JPEG::JPEG UNKNOWN IMPORTED)
    set_target_properties(JPEG::JPEG PROPERTIES
        IMPORTED_LOCATION "${MITSUBA_DEPENDENCY_LIBRARY_DIR}/jpeg.lib"
        INTERFACE_INCLUDE_DIRECTORIES "${MITSUBA_DEPENDENCY_INCLUDE_DIR}")
    set(JPEG_FOUND TRUE)

    set(OpenEXR_FOUND TRUE)
    set(MITSUBA_OPENEXR_INCLUDE_DIRS
        "${MITSUBA_DEPENDENCY_INCLUDE_DIR}/OpenEXR"
        "${MITSUBA_DEPENDENCY_INCLUDE_DIR}")
    set(MITSUBA_OPENEXR_LIBRARIES
        "${MITSUBA_DEPENDENCY_LIBRARY_DIR}/IlmImf.lib"
        "${MITSUBA_DEPENDENCY_LIBRARY_DIR}/IlmThread.lib"
        "${MITSUBA_DEPENDENCY_LIBRARY_DIR}/Iex.lib"
        "${MITSUBA_DEPENDENCY_LIBRARY_DIR}/IexMath.lib"
        "${MITSUBA_DEPENDENCY_LIBRARY_DIR}/Half.lib"
        "${MITSUBA_DEPENDENCY_LIBRARY_DIR}/Imath.lib"
        ZLIB::ZLIB)

    set(FFTW3_INCLUDE_DIR "${MITSUBA_DEPENDENCY_INCLUDE_DIR}")
    set(FFTW3_LIBRARY "${MITSUBA_DEPENDENCY_LIBRARY_DIR}/libfftw3-3.lib")
else()
    find_package(Boost 1.80 REQUIRED MODULE COMPONENTS system filesystem thread)
    find_package(XercesC CONFIG QUIET)

    if(NOT XercesC_FOUND)
        find_package(XercesC REQUIRED MODULE)
    endif()

    find_package(Eigen3 3.0 QUIET NO_MODULE)

    if(NOT TARGET Eigen3::Eigen)
        find_path(EIGEN3_INCLUDE_DIR Eigen/Core PATH_SUFFIXES eigen3)

        if(NOT EIGEN3_INCLUDE_DIR)
            message(FATAL_ERROR "Eigen 3.x was not found (install Eigen or set EIGEN3_INCLUDE_DIR).")
        endif()

        add_library(mitsuba-eigen INTERFACE)
        target_include_directories(mitsuba-eigen INTERFACE "${EIGEN3_INCLUDE_DIR}")
        add_library(Eigen3::Eigen ALIAS mitsuba-eigen)
    endif()

    find_package(GLEW REQUIRED)
    find_package(ZLIB REQUIRED)
    find_package(PNG QUIET)
    find_package(JPEG QUIET)
    find_package(OpenEXR QUIET)
    find_path(FFTW3_INCLUDE_DIR fftw3.h)
    find_library(FFTW3_LIBRARY NAMES fftw3)
    find_library(FFTW3_THREADS_LIBRARY NAMES fftw3_threads)
    set(MITSUBA_OPENEXR_INCLUDE_DIRS ${OpenEXR_INCLUDE_DIRS})
    set(MITSUBA_OPENEXR_LIBRARIES ${OpenEXR_LIBRARIES})
endif()

if(NOT TARGET OpenGL::GLU)
    message(FATAL_ERROR "OpenGL GLU was not found.")
endif()

if(NOT TARGET GLEW::GLEW AND NOT GLEW_LIBRARIES)
    message(FATAL_ERROR "GLEW was not found.")
endif()

if(UNIX AND NOT APPLE)
    find_package(X11 REQUIRED)
    find_library(XF86VM_LIBRARY NAMES Xxf86vm)

    if(NOT XF86VM_LIBRARY)
        message(FATAL_ERROR "Xxf86vm was not found (install libxxf86vm-dev).")
    endif()
endif()

add_library(mitsuba-common INTERFACE)
target_include_directories(mitsuba-common INTERFACE "${PROJECT_SOURCE_DIR}/include")

if(MITSUBA_USE_BUNDLED_DEPENDENCIES)
    target_include_directories(mitsuba-common INTERFACE "${MITSUBA_DEPENDENCY_INCLUDE_DIR}")
endif()

if(MITSUBA_BOOST_ROOT)
    target_include_directories(mitsuba-common BEFORE INTERFACE "${Boost_INCLUDE_DIRS}")
endif()

target_link_libraries(mitsuba-common INTERFACE
    Boost::system Boost::filesystem Boost::thread XercesC::XercesC Eigen3::Eigen ZLIB::ZLIB)
target_compile_definitions(mitsuba-common INTERFACE
    SPECTRUM_SAMPLES=${MITSUBA_SPECTRUM_SAMPLES} GLEW_MX)

if(MITSUBA_BOOST_ROOT)
    target_compile_definitions(mitsuba-common INTERFACE BOOST_BIND_GLOBAL_PLACEHOLDERS)
endif()

if(MITSUBA_DEBUG_CHECKS)
    target_compile_definitions(mitsuba-common INTERFACE MTS_DEBUG)
endif()

if(MITSUBA_SINGLE_PRECISION)
    target_compile_definitions(mitsuba-common INTERFACE SINGLE_PRECISION)
endif()

if(MITSUBA_ENABLE_SSE)
    target_compile_definitions(mitsuba-common INTERFACE MTS_SSE)
endif()

if(MITSUBA_ENABLE_COHERENT_RT)
    target_compile_definitions(mitsuba-common INTERFACE MTS_HAS_COHERENT_RT)
endif()

if(WIN32)
    target_compile_definitions(mitsuba-common INTERFACE WIN32 WIN64 OPENEXR_DLL)
    target_link_libraries(mitsuba-common INTERFACE psapi ws2_32 opengl32 glu32 gdi32 user32)
elseif(APPLE)
    target_link_libraries(mitsuba-common INTERFACE OpenGL::GL "-framework Cocoa" "-framework CoreFoundation")
else()
    target_link_libraries(mitsuba-common INTERFACE
        OpenGL::GL OpenGL::GLU X11::X11 "${XF86VM_LIBRARY}" ${CMAKE_DL_LIBS} m pthread)
endif()

if(TARGET GLEW::GLEW)
    target_link_libraries(mitsuba-common INTERFACE GLEW::GLEW)
else()
    target_link_libraries(mitsuba-common INTERFACE ${GLEW_LIBRARIES})
    target_include_directories(mitsuba-common INTERFACE ${GLEW_INCLUDE_DIRS})
endif()

if(PNG_FOUND)
    target_compile_definitions(mitsuba-common INTERFACE MTS_HAS_LIBPNG=1)
    target_link_libraries(mitsuba-common INTERFACE PNG::PNG)
endif()

if(JPEG_FOUND)
    target_compile_definitions(mitsuba-common INTERFACE MTS_HAS_LIBJPEG=1)
    target_link_libraries(mitsuba-common INTERFACE JPEG::JPEG)
endif()

if(OpenEXR_FOUND)
    target_compile_definitions(mitsuba-common INTERFACE MTS_HAS_OPENEXR=1)

    if(TARGET OpenEXR::OpenEXR)
        target_link_libraries(mitsuba-common INTERFACE OpenEXR::OpenEXR)
    elseif(TARGET OpenEXR::IlmImf)
        target_link_libraries(mitsuba-common INTERFACE OpenEXR::IlmImf)
    elseif(MITSUBA_OPENEXR_LIBRARIES)
        target_link_libraries(mitsuba-common INTERFACE ${MITSUBA_OPENEXR_LIBRARIES})
        target_include_directories(mitsuba-common INTERFACE ${MITSUBA_OPENEXR_INCLUDE_DIRS})
    endif()
endif()

if(FFTW3_INCLUDE_DIR AND FFTW3_LIBRARY)
    target_compile_definitions(mitsuba-common INTERFACE MTS_HAS_FFTW=1)
    target_include_directories(mitsuba-common INTERFACE "${FFTW3_INCLUDE_DIR}")
    target_link_libraries(mitsuba-common INTERFACE "${FFTW3_LIBRARY}")

    if(FFTW3_THREADS_LIBRARY)
        target_link_libraries(mitsuba-common INTERFACE "${FFTW3_THREADS_LIBRARY}")
    endif()
endif()

if(MITSUBA_ENABLE_OPENMP)
    find_package(OpenMP QUIET)

    if(OpenMP_CXX_FOUND)
        target_link_libraries(mitsuba-common INTERFACE OpenMP::OpenMP_CXX)
    endif()
endif()

if(MSVC)
    target_compile_options(mitsuba-common INTERFACE /bigobj /EHsc /fp:fast)
else()
    target_compile_options(mitsuba-common INTERFACE -fvisibility=hidden)
endif()

if(WIN32)
    # Collect the runtime DLLs of the bundled third-party dependencies and of
    # Boost so that they can be copied next to the build-tree executables
    file(GLOB MITSUBA_RUNTIME_DLLS "${MITSUBA_DEPENDENCY_LIBRARY_DIR}/*.dll")

    foreach(_boost_lib_dir IN LISTS Boost_LIBRARY_DIRS)
        file(GLOB _boost_dlls
            "${_boost_lib_dir}/boost_filesystem*.dll"
            "${_boost_lib_dir}/boost_system*.dll"
            "${_boost_lib_dir}/boost_thread*.dll"
            "${_boost_lib_dir}/boost_chrono*.dll"
            "${_boost_lib_dir}/boost_atomic*.dll")
        list(APPEND MITSUBA_RUNTIME_DLLS ${_boost_dlls})
    endforeach()
endif()