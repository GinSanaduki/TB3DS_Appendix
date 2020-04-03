#!/usr/bin/gawk -f
# Victorinox_06.awk
# gawk -f Victorinox_06.awk

{
	gsub("▽","\n▽");
	gsub("　","");
	print;
}

