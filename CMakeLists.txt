cmake_minimum_required(VERSION 3.16)

project(ComputerSecurityLabs VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 6.5 REQUIRED COMPONENTS Quick Charts)

qt_standard_project_setup(REQUIRES 6.5)

qt_add_executable(appComputerSecurityLabs
    main.cpp
)

qt_add_qml_module(appComputerSecurityLabs
    URI ComputerSecurityLabs
    VERSION 1.0
    SOURCES constants.h
    SOURCES tools.h
    SOURCES iofile.h
    SOURCES qmltools.h
    SOURCES labcore1.h labcore1.cpp
    SOURCES geometry.h geometry.cpp
    SOURCES labcore2.h labcore2.cpp
    SOURCES labcore3.h labcore3.cpp
    SOURCES labcore4.h labcore4.cpp
    SOURCES labcore5.h labcore5.cpp
    SOURCES labcore6.h labcore6.cpp
    QML_FILES Main.qml
    QML_FILES Lab1.qml
    QML_FILES Lab2.qml
    QML_FILES Lab3.qml
    QML_FILES Lab4.qml
    QML_FILES Lab5.qml
    QML_FILES Lab6.qml
    QML_FILES Lab7.qml
    QML_FILES LoaderPlug.qml
    QML_FILES WButton.qml
    QML_FILES WStateButton.qml
    QML_FILES WPopUp.qml
    QML_FILES WTextField.qml
    QML_FILES WPlatform.qml
    QML_FILES WText.qml
)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appComputerSecurityLabs PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appComputerSecurityLabs
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appComputerSecurityLabs
    PRIVATE Qt6::Quick
    PRIVATE Qt6::Charts
    PRIVATE /home/f/Qt/6.6.1/gcc_64/lib/libqca-qt6.so
)

include(GNUInstallDirs)
install(TARGETS appComputerSecurityLabs
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
