#!/bin/bash

exe=lol
build_dir=build
clear
style_ok() {
   tput bold
   tput setaf 2
  # tput rev
}
style_w() {
   tput bold
   tput setaf 3
   tput rev
}

cmake_build() {
   style_ok
   echo "building"
   tput sgr0
   if [[ -d "${build_dir}" ]]; then
      cmake --build build -j8
   fi

   if [[ -f "${build_dir}/${exe}" ]]; then
      style_ok
      if [[ -f "${build_dir}/compile_commands.json" ]]; then
         echo "copying compile_commands.json"
         cp ./${build_dir}/compile_commands.json ./compile_commands.json
      else
         style_w
         echo "compile_commands.json not found"
         style_ok
      fi
      echo "running executable"
      tput sgr0
      ./build/${exe}
      style_w
      printf "\napplication exited\n"
      tput sgr0
   fi
}

cmake_run() {
   if [[ -d "${build_dir}" ]]; then
      rm -r ${build_dir}
      style_ok
      echo "deleted build directory ${build_dir} ${exe}"
      tput sgr0
   fi
   cmake -S./ -B ${build_dir} -D CMAKE_BUILD_TYPE=Debug -G "Ninja" -D CMAKE_CXX_COMPILER=clang++ 
   # -DCMAKE_TOOLCHAIN_FILE=/home/babayaga/Android/Sdk/ndk/22.1.7171670/build/cmake/android.toolchain.cmake
   #
   if [[ -d "${build_dir}" ]]; then
      cmake_build
   fi
}

if [[ $1 = conan ]]; then
   if [[ -d "conan_cmake" ]]; then
      rm -r conan_cmake
      style_ok
      echo "deleted build directory conan_cmake"
      tput sgr0
   fi
   conan install ./conan -if=./conan_cmake --profile=./conan/clang --build=missing 
   #--profile=./conan/armp
fi

if [[ $1 = f ]]; then
   cmake_run
fi

if [[ $1 = "" ]]; then
   cmake_build
fi

if [[ $1 = "git" ]]; then
   git add *
   if [[ $2 = "" ]]; then
      git commit -m "generated commit"
   else
      git commit -m "$2"
   fi
   git push origin master
fi
