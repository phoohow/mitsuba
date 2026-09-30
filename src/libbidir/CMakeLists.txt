add_library(mitsuba-bidir SHARED
    common.cpp
    rsampler.cpp
    vertex.cpp
    edge.cpp
    path.cpp
    verification.cpp
    util.cpp
    pathsampler.cpp
    mut_bidir.cpp
    mut_lens.cpp
    mut_caustic.cpp
    mut_mchain.cpp
    manifold.cpp
    mut_manifold.cpp
)
target_link_libraries(mitsuba-bidir PUBLIC mitsuba-render mitsuba-core mitsuba-common)
target_compile_definitions(mitsuba-bidir PRIVATE MTS_BUILD_MODULE=4)
mitsuba_set_output_dirs(mitsuba-bidir)