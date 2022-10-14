cmake_minimum_required(VERSION 3.24)

project(example LANGUAGES CXX)

set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${PROJECT_BINARY_DIR}/lib)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${PROJECT_BINARY_DIR}/lib)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${PROJECT_BINARY_DIR}/bin)

include(CTest)
include(GNUInstallDirs)

add_library(project_settings INTERFACE)
target_compile_features(project_settings INTERFACE cxx_std_17)

add_subdirectory(src)
add_subdirectory(app)
add_subdirectory(package)

if(BUILD_TESTING)
  find_package(doctest REQUIRED)
  add_subdirectory(test)
endif()
