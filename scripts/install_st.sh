#!/bin/bash

INSTALL_DIR=$HOME/pkg
ST_URL="https://git.suckless.org/st"

PATCH_DIR="patch"
PATCH_STUB="https://st.suckless.org/patches"
PATCH_ARR=( "solarized/st-no_bold_colors-20170623-b331da5.diff" \
  "solarized/st-solarized-dark-20180411-041912a.diff" \
  "alpha/st-alpha-0.8.2.diff" )
PATCH_APPLY=( "st-no_bold_colors-20170623-b331da5.diff" \
  "st-solarized-dark-20180411-041912a.diff" \
  "st-alpha-0.8.2.diff" )

#TODO
rm -rf $INSTALL_DIR/st

# make an installation directory and git clone the repo
mkdir -p $INSTALL_DIR
cd $INSTALL_DIR
git clone $ST_URL
cd ./st

# enter the repo and start collecting patches
mkdir -p $PATCH_DIR
for PATCH in "${PATCH_ARR[@]}"
do
  wget -qP $PATCH_DIR $PATCH_STUB/$PATCH
done

# apply patches (the order matters so I've listed them explicitly)
for PATCH in "${PATCH_APPLY[@]}"
do
  echo $PATCH_DIR/$PATCH
  patch -i $PATCH_DIR/$PATCH
done

# apply my changes for font and transparency
cp config.def.h config.h
# set 60% transparency
sed -i 's/float alpha = .*$/float alpha = 0.6;/' config.h
# set default font
sed -i 's/static char \*font = .*$/static char *font = "IBMPlexMono-Regular:pixelsize=16:antialias=true:autohint=true";/' config.h
# tweak background color to be a bit darker (brblack)
sed -i 's/002b36/001d24/' config.h

sudo make install
