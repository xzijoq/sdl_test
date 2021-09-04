cmake_minimum_required(VERSION 3.2)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)


project(lol)

set(CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/conan_cmake)
set(OPENSSL_USE_STATIC_LIBS TRUE)



find_package(fmt REQUIRED)
find_package(OpenSSL REQUIRED)
find_package(SDL2 REQUIRED)



add_executable(lol)
target_sources(lol PRIVATE src/main.cpp)

target_link_libraries(lol PRIVATE fmt::fmt OpenSSL::Crypto SDL2::SDL2)
