#!/bin/bash
set -ex

sudo apt-get install -y \
    libcurl4-openssl-dev libgif-dev libjpeg-dev zlib1g-dev libpng-dev libtinyxml-dev \
    libpixman-1-dev libfreetype6-dev libharfbuzz-dev \
    libx11-dev libxcursor-dev libxi-dev xvfb \
    ninja-build jq

git_tag=$(curl -sL https://api.github.com/repos/aseprite/aseprite/releases/latest | jq -r '.tag_name')

if [ ! -d aseprite ]; then
    git clone https://github.com/aseprite/aseprite -b $git_tag --recursive -j $(nproc)
else
    cd aseprite
    git fetch
    git checkout $git_tag
    git submodule update --init --recursive -j $(nproc)
    cd ..
fi
cd aseprite
mkdir -p build
cd build
cmake .. -G Ninja \
    -DCMAKE_INSTALL_PREFIX=../../aseprite-dist \
    -DCMAKE_BUILD_TYPE=Debug \
    -DENABLE_TESTS=OFF \
    -DENABLE_UI=OFF \
    -DENABLE_SCRIPTING=OFF \
    -DWITH_WEBP_SUPPORT=OFF \
    -DUSE_SHARED_CMARK=OFF \
    -DUSE_SHARED_CURL=ON \
    -DUSE_SHARED_GIFLIB=ON \
    -DUSE_SHARED_JPEGLIB=ON \
    -DUSE_SHARED_ZLIB=ON \
    -DUSE_SHARED_LIBPNG=ON \
    -DUSE_SHARED_TINYXML=ON \
    -DUSE_SHARED_PIXMAN=ON \
    -DUSE_SHARED_FREETYPE=ON \
    -DUSE_SHARED_HARFBUZZ=ON
ninja install
cd ../..
xvfb-run ./aseprite-dist/bin/aseprite --version
