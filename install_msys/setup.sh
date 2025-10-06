#!/bin/bash

# cp install_msys/.inputrc ~/.inputrc
# micro ~/.bashrc

pacman -S --noconfirm \
  mingw64/mingw-w64-x86_64-binutils \
  mingw64/mingw-w64-x86_64-toolchain \
  mingw64/mingw-w64-x86_64-ninja \
  mingw64/mingw-w64-x86_64-cmake \
  mingw64/mingw-w64-x86_64-go \
  mingw64/mingw-w64-x86_64-python-conan \
  diffutils \
  git \
  make
# setup_micro.sh

mkdir -p ~/projects/management
mkdir -p ~/projects/dev/cpp/amberval
mkdir -p ~/projects/dev/python
mkdir -p ~/projects/dev/bash

# conan profile detect --force
# In default conan profile:
# gnu17 to gnu20
# Add:
# [conf]
# ## MSYS2:
# tools.microsoft.bash:subsystem=msys2
# tools.microsoft.bash:path=C:/msys64/usr/bin/bash
# ## /MSYS2
# tools.cmake.cmaketoolchain:generator=Ninja
# 
# [options]
# gtest/*:shared=True


# pacman -S mingw-w64-x86_64-tesseract-ocr
