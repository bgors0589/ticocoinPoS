#!/bin/bash
# create multiresolution windows icon
ICON_SRC=../../src/qt/res/icons/ticocoin.png
ICON_DST=../../src/qt/res/icons/ticocoin.ico
convert ${ICON_SRC} -resize 16x16 ticocoin-16.png
convert ${ICON_SRC} -resize 32x32 ticocoin-32.png
convert ${ICON_SRC} -resize 48x48 ticocoin-48.png
convert ticocoin-48.png ticocoin-32.png ticocoin-16.png ${ICON_DST}

