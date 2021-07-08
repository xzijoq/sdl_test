#!/bin/bash

exe=lol
build_dir=build

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
   cmake -S./ -B ${build_dir} -D CMAKE_BUILD_TYPE=Debug -D CMAKE_CXX_COMPILER=clang++ -G "Ninja"
   if [[ -d "${build_dir}" ]]; then
      cmake_build
   fi
}

if [[ $1 = conan ]]; then
   conan install ./conan -if=./conan_cmake --build=missing --profile=./conan/clang
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
