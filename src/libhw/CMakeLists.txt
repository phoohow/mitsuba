set(MITSUBA_HW_SOURCES
    session.cpp
    device.cpp
    gputexture.cpp
    gpugeometry.cpp
    gpuprogram.cpp
    renderer.cpp
    glrenderer.cpp
    glprogram.cpp
    glgeometry.cpp
    gltexture.cpp
    gpusync.cpp
    glsync.cpp
    vpl.cpp
    font.cpp
    viewer.cpp
    basicshader.cpp
    shadow.cpp
)

if(WIN32)
    list(APPEND MITSUBA_HW_SOURCES wglsession.cpp wgldevice.cpp wglrenderer.cpp)
elseif(APPLE)
    list(APPEND MITSUBA_HW_SOURCES nsglsession.mm nsgldevice.mm nsglrenderer.mm)
else()
    list(APPEND MITSUBA_HW_SOURCES x11session.cpp x11device.cpp glxdevice.cpp glxrenderer.cpp)
endif()

add_library(mitsuba-hw SHARED ${MITSUBA_HW_SOURCES})
target_link_libraries(mitsuba-hw PUBLIC mitsuba-render mitsuba-core mitsuba-common)
target_compile_definitions(mitsuba-hw PRIVATE MTS_BUILD_MODULE=3)
mitsuba_set_output_dirs(mitsuba-hw)