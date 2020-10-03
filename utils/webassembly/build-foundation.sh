#!/bin/bash
set -ex
DESTINATION_TOOLCHAIN=$1
SOURCE_PATH="$(cd "$(dirname $0)/../../.." && pwd)"

FOUNDATION_BUILD="$SOURCE_PATH/target-build/Ninja-Release/foundation-wasi-wasm32"

mkdir -p $FOUNDATION_BUILD
cd $FOUNDATION_BUILD

cmake -G Ninja \
  -DTARGET_TOOLCHAIN_PATH="$DESTINATION_TOOLCHAIN" \
  -DCMAKE_STAGING_PREFIX="$DESTINATION_TOOLCHAIN/usr" \
  -DCMAKE_TOOLCHAIN_FILE="$SOURCE_PATH/swift/utils/webassembly/toolchain-wasi.cmake" \
  -DWASI_SYSROOT_PATH="$SOURCE_PATH/wasi-sysroot" \
  -DICU_ROOT="$SOURCE_PATH/icu_out" \
  -DBUILD_SHARED_LIBS=OFF \
  -DCMAKE_Swift_COMPILER_FORCED=ON \
  "${SOURCE_PATH}/swift-corelibs-foundation"
  
ninja -v
ninja -v install

# .swiftdoc and .swiftmodule files should live in `swift`, not in `swift_static`
mv $DESTINATION_TOOLCHAIN/usr/lib/swift_static/wasi/wasm32/Foundation.swift* \
  $DESTINATION_TOOLCHAIN/usr/lib/swift/wasi/wasm32
