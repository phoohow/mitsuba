if(NOT MITSUBA_BUILD_GUI)
    return()
endif()

find_package(Qt5 QUIET COMPONENTS Core Gui Widgets OpenGL Xml XmlPatterns Network)

if(NOT Qt5_FOUND)
    message(STATUS "Qt 5 was not found; the graphical interface is disabled")
    return()
endif()

file(GLOB_RECURSE MITSUBA_GUI_SOURCES CONFIGURE_DEPENDS
    "${CMAKE_CURRENT_SOURCE_DIR}/*.cpp"
    "${CMAKE_CURRENT_SOURCE_DIR}/*.ui"
    "${CMAKE_CURRENT_SOURCE_DIR}/*.qrc")

if(APPLE)
    list(APPEND MITSUBA_GUI_SOURCES previewsettingsdlg_cocoa_impl.mm)
endif()

add_executable(mtsgui ${MITSUBA_GUI_SOURCES})
set_target_properties(mtsgui PROPERTIES AUTOMOC ON AUTOUIC ON AUTORCC ON)
target_include_directories(mtsgui PRIVATE "${CMAKE_CURRENT_SOURCE_DIR}")
set(MITSUBA_QT_INCLUDE_DIRS)

foreach(module IN ITEMS Core Gui Widgets OpenGL Xml XmlPatterns Network)
    get_target_property(module_include_dirs Qt5::${module} INTERFACE_INCLUDE_DIRECTORIES)

    if(module_include_dirs)
        list(APPEND MITSUBA_QT_INCLUDE_DIRS ${module_include_dirs})
    endif()
endforeach()

target_include_directories(mtsgui SYSTEM BEFORE PRIVATE ${MITSUBA_QT_INCLUDE_DIRS})
target_link_libraries(mtsgui PRIVATE
    mitsuba-core mitsuba-render mitsuba-hw mitsuba-common
    Qt5::Core Qt5::Gui Qt5::Widgets Qt5::OpenGL Qt5::Xml Qt5::XmlPatterns Qt5::Network)

if(TARGET mitsuba-converter)
    target_link_libraries(mtsgui PRIVATE mitsuba-converter)
endif()

if(WIN32)
    target_sources(mtsgui PRIVATE "${CMAKE_SOURCE_DIR}/data/windows/mitsuba_res.rc")
    target_compile_definitions(mtsgui PRIVATE _WINDOWS MTS_CUSTOM_QTMAIN MTSGUI_STATIC_QFILEDIALOG=1)

    if(TARGET Qt5::WinMain)
        target_link_libraries(mtsgui PRIVATE Qt5::WinMain)
    endif()
endif()

mitsuba_set_output_dirs(mtsgui)
install(TARGETS mtsgui RUNTIME DESTINATION .)