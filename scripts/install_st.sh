#!/bin/bash

INSTALL_DIR=$HOME/pkg
ST_URL="https://dl.suckless.org/st/st-0.8.2.tar.gz"
ST_TAR="st-0.8.2"

PATCH_DIR="patch"
PATCH_STUB="https://st.suckless.org/patches"
PATCH_ARR=( \
  "scrollback/st-scrollback-0.8.2.diff" \
  "scrollback/st-scrollback-mouse-0.8.2.diff" \
  "scrollback/st-scrollback-mouse-altscreen-0.8.diff" \
  "solarized/st-no_bold_colors-20170623-b331da5.diff" \
  "solarized/st-solarized-dark-20180411-041912a.diff" \
  "alpha/st-alpha-0.8.2.diff" \
  "clipboard/st-clipboard-20180309-c5ba9c0.diff" )
PATCH_APPLY=( \
  "st-scrollback-0.8.2.diff" \
  "st-scrollback-mouse-0.8.2.diff" \
  "st-scrollback-mouse-altscreen-0.8.diff" \
  "st-no_bold_colors-20170623-b331da5.diff" \
  "st-solarized-dark-20180411-041912a.diff" \
  "st-alpha-0.8.2.diff" \
  "st-clipboard-20180309-c5ba9c0.diff" )

rm -rf $INSTALL_DIR/$ST_TAR

# make an installation directory and git clone the repo
mkdir -p $INSTALL_DIR
cd $INSTALL_DIR
curl $ST_URL --output ./$ST_TAR
tar -xvzf $ST_TAR
rm $ST_TAR.*
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

# apply my changes for font and transparency
cp config.def.h config.h
# set 80% transparency
sed -i 's/float alpha = .*$/float alpha = 0.8;/' config.h
# set default font
sed -i 's/static char \*font = .*$/static char *font = "IBMPlexMono-Regular:pixelsize=16:antialias=true:autohint=true";/' config.h
# tweak background color to be a bit darker (brblack)
sed -i 's/002b36/001d24/' config.h
# scroll faster (3 at a time instead of 1)
sed -i 's/kscrollup,.*{\.i =  1}/kscrollup,   {\.i =  3}/' config.h
sed -i 's/kscrolldown,.*{\.i =  1}/kscrolldown, {\.i =  3}/' config.h

sudo make install
