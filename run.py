import os
import subprocess
import sys
import argparse
import shutil

from os import path
from os.path import join
from os.path import isdir
from os.path import isfile

cwd = os.getcwd()
build_dir = 'build'
build_dir_path = join(cwd, build_dir)

target = 'lol'
target_path = join(build_dir_path, target)

compiler = 'clang++'
build_type = 'Debug'
generator = 'Ninja'

conan_dir = 'conan'
conan_target = 'conan_cmake'
conan_dir_path = join(cwd, conan_dir)
conan_profile = 'clang'
conan_profile_path = join(conan_dir_path, conan_profile)


def p_msg(skk):
    print("\033[30;102mMsg: {}\033[00m".format(skk))


def p_wrn(skk):
    print("\033[30;103;3;4mWarn: {}\033[00m".format(skk))


def p_err(skk):
    print("\033[30;101;3;4mErr: {}\033[00m".format(skk))


print(cwd)


def cmake_build():
    p_msg("Building")
    if not os.path.isdir(build_dir):
        p_err("Build Directory not found")
        return
    if os.path.isfile(target_path):
        p_msg(f"Deleting Target: {target}")
        os.remove(target_path)
    subprocess.run([f'cmake --build {build_dir} -j8 '], shell=True)
    if isfile(target_path):
        if isfile(join(build_dir_path, 'compile_commands.json')):
            os.remove(join(cwd, 'compile_commands.json'))
            shutil.copy(join(build_dir, 'compile_commands.json'),
                        join(cwd, 'compile_commands.json'))
        else:
            p_wrn("can find compile_commands.json")
        p_msg("Running Executable")
        subprocess.run([f'{target_path}'])
        print("\n")
        p_msg("End")
    pass


def cmake_run():
    if not isfile(join(cwd, 'CMakeLists.txt')):
        p_err("CMakeLists.txt not found")
    if isdir(build_dir_path):
        p_msg("Deleting: %s" % build_dir_path)
        shutil.rmtree(build_dir_path)

    cmake_v = 'cmake -S./ -B {} -D CMAKE_BUILD_TYPE={} -D CMAKE_CXX_COMPILER={} -G {}'.format(
        build_dir, build_type, compiler, generator)
    cmake_r = f'cmake -S./ -B {build_dir} -D CMAKE_BUILD_TYPE={build_type} -D CMAKE_CXX_COMPILER={compiler} -G {generator}'
    p_msg("Running: %s" % cmake_r)
    ero = subprocess.run([cmake_r], shell=True)

    if not (isdir(build_dir_path) and ero.returncode == 0):
        p_err("cmake_build() failed")
        return
    cmake_build()
    pass


parser = argparse.ArgumentParser()
parser.add_argument('what', help="wow")
args = parser.parse_args()

what = args.what

if (what == 'r' or what == 'run'):
    cmake_run()

elif what == 'b' or what == 'build':
    cmake_build()
elif what == 'c' or what == 'conan':
    if (isdir(conan_dir_path)):
        if isfile(conan_profile_path):
            p_msg(f"Deleting: {conan_dir_path}")
            conan_bt = join(cwd, conan_target)
            conan_r = f'conan install {conan_dir_path} -if={conan_bt} --build=missing --profile={conan_profile_path}'
            p_msg(f'Running Conan: ')
            subprocess.run([conan_r], shell=True)
        else:
            p_wrn(f'Profile not found: {conan_profile}')
    else:
        p_wrn(f"Conan Directory Not Found: {conan_dir_path}")

else:
    print("what do you want")
