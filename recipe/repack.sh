#!/bin/bash
echo "Building ${PKG_NAME}."
set -ex

# for subpackages, we have named our extracted locations according to the subpackage name
#    That's what this $PKG_NAME is doing - picking the right subfolder to rsync

src="$SRC_DIR/$PKG_NAME"

# conda-build doesn't like .dbg files since patchelf doesn't return any runtime paths.
# https://github.com/conda/conda-build/blob/25.1.1/conda_build/post.py#L597
find "$src" -iname "*.dbg" -delete
cp -av "$src"/* "$PREFIX/"

# replace old info folder with our new regenerated one
rm -rvf "$PREFIX/info"
