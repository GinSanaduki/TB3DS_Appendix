#!/usr/bin/gawk -f
# Victorinox_01.awk
# gawk -f Victorinox_01.awk

{
	sub(/^\s*?/,"");
	sub(/^\t*?/,"");
	print;
}

