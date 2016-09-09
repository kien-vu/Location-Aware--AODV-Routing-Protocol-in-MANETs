#!/bin/sh
patch -p1 < ns-2.33-hls.patch
if [ -e ./Makefile ]
then
	patch -p1 < ns-2.33-hls.Makefile.patch
fi
