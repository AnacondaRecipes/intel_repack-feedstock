#!/bin/bash

# not all packages have the license file.  Copy it from mkl, where we know it exists
cp -f $SRC_DIR/mkl/info/licenses/license.txt $SRC_DIR
# ro by default.  Makes installations not cleanly removable.
chmod 664 $SRC_DIR/license.txt

cp $RECIPE_DIR/site.cfg $PREFIX/site.cfg
echo library_dirs = $PREFIX/lib  >> $PREFIX/site.cfg
echo include_dirs = $PREFIX/include  >> $PREFIX/site.cfg

if [[ "${target_platform}" == "linux-64" ]]; then
    # mkl-devel 2023.1.0 b0 is not packaged correctly on linux-64
    cp -rv $SRC_DIR/$PKG_NAME/$PKG_NAME/ $PREFIX
else
    cp -rv $SRC_DIR/$PKG_NAME/ $PREFIX
fi

rm -rf $PREFIX/info
