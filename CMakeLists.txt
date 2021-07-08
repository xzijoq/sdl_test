cmake_minimum_required(VERSION 3.2)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

project(lol)


set(CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/conan_cmake)
add_executable(lol)


find_package(fmt REQUIRED)
find_package(SDL2 REQUIRED)

target_sources(lol PRIVATE src/main.cpp)

target_include_directories(lol PRIVATE ${SDL_INCLUDE_DIRS})
target_link_libraries(lol PRIVATE fmt::fmt ${SDL_LIBRARIES} )
