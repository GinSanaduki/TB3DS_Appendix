#!/usr/bin/gawk -f
# Victorinox_08.awk
# gawk -f Victorinox_08.awk

{
	gsub("☆","");
	gsub("◎","");
	gsub("○","");
	gsub("▽","");
	gsub("<b>","");
	gsub("</b>","");
	print;
}

