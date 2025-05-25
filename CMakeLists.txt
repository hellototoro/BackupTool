cmake_minimum_required(VERSION 3.16.0)

project(BackupTool VERSION 1.0.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# 设置输出目录
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)

# 为不同配置设置输出目录
foreach(OUTPUTCONFIG ${CMAKE_CONFIGURATION_TYPES})
    string(TOUPPER ${OUTPUTCONFIG} OUTPUTCONFIG)
    set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_${OUTPUTCONFIG} ${CMAKE_BINARY_DIR}/bin)
    set(CMAKE_LIBRARY_OUTPUT_DIRECTORY_${OUTPUTCONFIG} ${CMAKE_BINARY_DIR}/lib)
    set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY_${OUTPUTCONFIG} ${CMAKE_BINARY_DIR}/lib)
endforeach()

# 查找Qt组件
find_package(Qt6 REQUIRED COMPONENTS Core Widgets Qml Quick)

# Qt标准项目设置
qt_standard_project_setup()

# 源文件
set(SOURCES
    src/main.cpp
    src/backupmanager.cpp
    src/systeminfo.cpp
    src/configbackup.cpp
)

# 头文件
set(HEADERS
    src/backupmanager.h
    src/systeminfo.h
    src/configbackup.h
)

# 创建可执行文件
qt_add_executable(BackupTool ${SOURCES} ${HEADERS})

# 添加QML模块
qt_add_qml_module(BackupTool
    URI BackupTool
    VERSION 1.0
    QML_FILES
        qml/Main.qml
        qml/BackupCard.qml
        qml/ProgressDialog.qml
        qml/SettingsPage.qml
)

# 链接Qt库
target_link_libraries(BackupTool PRIVATE
    Qt6::Core
    Qt6::Widgets
    Qt6::Qml
    Qt6::Quick
)

# 包含目录
target_include_directories(BackupTool PRIVATE src)

# Windows特定设置
if(WIN32)
    set_target_properties(BackupTool PROPERTIES
        WIN32_EXECUTABLE TRUE
    )
    
    # 如果有图标文件，添加资源文件
    if(EXISTS "${CMAKE_SOURCE_DIR}/resources/icon.ico")
        target_sources(BackupTool PRIVATE resources/icon.ico)
    endif()
endif()

# 安装规则
install(TARGETS BackupTool
    BUNDLE DESTINATION .
    RUNTIME DESTINATION bin
)

# 复制配置文件
install(DIRECTORY config/
    DESTINATION bin/config
    FILES_MATCHING PATTERN "*.json"
)
