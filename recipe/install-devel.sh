#!/bin/bash
echo "Building ${PKG_NAME}."
set -ex

# not all packages have the license file.  Copy it from mkl, where we know it exists
cp -f "$SRC_DIR/mkl/info/licenses/license.txt" "$SRC_DIR"
# ro by default.  Makes installations not cleanly removable.
chmod 664 "$SRC_DIR/license.txt"

cp $RECIPE_DIR/site.cfg $PREFIX/site.cfg
echo library_dirs = $PREFIX/lib  >> $PREFIX/site.cfg
echo include_dirs = $PREFIX/include  >> $PREFIX/site.cfg

cp -rv $SRC_DIR/$PKG_NAME/* $PREFIX

# correct .pc files that point to intel64 lib dir instead of just lib
find "$PREFIX/lib/pkgconfig/" -type f -name '*.pc' -exec sed -i -e 's,libdir=\(.*\)/intel64,libdir=\1,g' {} +

# replace old info folder with our new regenerated one
rm -rf "$PREFIX/info"
