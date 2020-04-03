#!/usr/bin/gawk -f
# Victorinox_03.awk
# gawk -f Victorinox_03.awk

{
	if(NR % 3){
		ORS="\t";
	} else {
		ORS="\n";
	}
	print;
}

