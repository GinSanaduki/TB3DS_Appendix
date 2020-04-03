#!/usr/bin/gawk -f
# Victorinox_05_02.awk
# gawk -f Victorinox_05_02.awk

{
	gsub(/<script async src=.*?><\/script>/,"");
	gsub("<br />","");
	print;
}

