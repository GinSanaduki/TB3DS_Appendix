#!/usr/bin/gawk -f
# Victorinox_04_02.awk
# gawk -f Victorinox_04_02.awk

{
	gsub("<br/>","\n<br/>");
	print;
}

