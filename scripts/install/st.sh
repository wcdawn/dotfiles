#!/bin/bash

INSTALL_DIR=$HOME/pkg

# patches only work with old version (0.8.2)
ST_URL='https://dl.suckless.org/st/st-0.8.2.tar.gz'
ST_TAR='st-0.8.2'

PATCH_DIR='patch'
PATCH_STUB='https://st.suckless.org/patches'
PATCH_ARR=( \
  'boxdraw/st-boxdraw_v2-0.8.2.diff' \
  'alpha/st-alpha-0.8.2.diff' \
  'xresources/st-xresources-20190105-3be4cf1.diff' \
  'scrollback/st-scrollback-0.8.2.diff' \
  'scrollback/st-scrollback-mouse-0.8.2.diff' \
  'scrollback/st-scrollback-mouse-altscreen-0.8.diff' \
  'clipboard/st-clipboard-20180309-c5ba9c0.diff' \
)
PATCH_APPLY=( \
  'st-boxdraw_v2-0.8.2.diff' \
  'st-alpha-0.8.2.diff' \
  'st-xresources-20190105-3be4cf1.diff' \
  'st-scrollback-0.8.2.diff' \
  'st-scrollback-mouse-0.8.2.diff' \
  'st-scrollback-mouse-altscreen-0.8.diff' \
  'st-clipboard-20180309-c5ba9c0.diff' \
)

rm -rf $INSTALL_DIR/$ST_TAR

# make an installation directory and git clone the repo
mkdir -p $INSTALL_DIR
cd $INSTALL_DIR
curl $ST_URL --output ./$ST_TAR
tar -xvzf $ST_TAR
cd ./$ST_TAR

# enter the repo and start collecting patches
count=0
mkdir -p $PATCH_DIR
for PATCH in "${PATCH_ARR[@]}"
do
  curl -s $PATCH_STUB/$PATCH > $PATCH_DIR/${PATCH_APPLY[count]}
  patch -i $PATCH_DIR/${PATCH_APPLY[count]}
  count=$(( $count + 1 ))
done

CONFIG='config.h'

# apply my changes for font and transparency
cp config.def.h $CONFIG

# set 90% transparency
sed -i 's/float alpha = .*$/float alpha = 0.9;/' $CONFIG

# disable support for cursor color and fix the cursor colors
sed -i 's/^.*cursorColor.*$//' $CONFIG
sed -i 's/defaultcs = .*$/defaultcs = 257;/' $CONFIG
sed -i 's/defaultrcs = .*$/defaultrcs = 256;/' $CONFIG

# background and foreground color must be fixed when using alpha
sed -i 's/defaultbg = .*$/defaultbg = 256;/' $CONFIG
sed -i 's/defaultfg = .*$/defaultfg = 257;/' $CONFIG

# pick the underline cursor
sed -i 's/cursorshape = .*$/cursorshape = 4;/' $CONFIG

# scroll faster (3 at a time instead of 1)
sed -i 's/kscrollup,.*{\.i =  1}/kscrollup,   {\.i =  3}/' $CONFIG
sed -i 's/kscrolldown,.*{\.i =  1}/kscrolldown, {\.i =  3}/' $CONFIG

# enable boxdraw
sed -i 's/boxdraw = .*$/boxdraw = 1;/' $CONFIG
sed -i 's/boxdraw_bold = .*$/boxdraw_bold = 1;/' $CONFIG
sed -i 's/boxdraw_braille = .*$/boxdraw_braille = 1;/' $CONFIG

sudo make install
