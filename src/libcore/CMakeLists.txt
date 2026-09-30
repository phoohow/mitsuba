add_library(mitsuba-core SHARED
    class.cpp
    object.cpp
    statistics.cpp
    thread.cpp
    brent.cpp
    logger.cpp
    appender.cpp
    formatter.cpp
    lock.cpp
    qmc.cpp
    random.cpp
    timer.cpp
    util.cpp
    properties.cpp
    half.cpp
    transform.cpp
    spectrum.cpp
    aabb.cpp
    stream.cpp
    math.cpp
    fstream.cpp
    plugin.cpp
    triangle.cpp
    bitmap.cpp
    fmtconv.cpp
    serialization.cpp
    sstream.cpp
    cstream.cpp
    mstream.cpp
    sched.cpp
    sched_remote.cpp
    sshstream.cpp
    zstream.cpp
    shvector.cpp
    fresolver.cpp
    rfilter.cpp
    quad.cpp
    mmap.cpp
    chisquare.cpp
    warp.cpp
    vmf.cpp
    tls.cpp
    ssemath.cpp
    spline.cpp
    track.cpp
)

if(WIN32)
    target_sources(mitsuba-core PRIVATE getopt.c)
endif()

if(APPLE)
    target_sources(mitsuba-core PRIVATE platform_darwin.mm)
endif()

target_link_libraries(mitsuba-core PUBLIC mitsuba-common)
target_compile_definitions(mitsuba-core PRIVATE MTS_BUILD_MODULE=1)

if(WIN32)
    target_link_libraries(mitsuba-core PRIVATE psapi)
endif()

mitsuba_set_output_dirs(mitsuba-core)

if(WIN32)
    # Copy the data files (XML schema, IOR spectra, microfacet data) next to
    # mitsuba-core.dll so that the build-tree executables can resolve them
    add_custom_command(TARGET mitsuba-core POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy_directory
        "${PROJECT_SOURCE_DIR}/data/schema" "$<TARGET_FILE_DIR:mitsuba-core>/data/schema"
        COMMAND ${CMAKE_COMMAND} -E copy_directory
        "${PROJECT_SOURCE_DIR}/data/ior" "$<TARGET_FILE_DIR:mitsuba-core>/data/ior"
        COMMAND ${CMAKE_COMMAND} -E copy_directory
        "${PROJECT_SOURCE_DIR}/data/microfacet" "$<TARGET_FILE_DIR:mitsuba-core>/data/microfacet")
endif()