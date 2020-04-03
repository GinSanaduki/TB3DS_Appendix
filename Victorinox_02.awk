#!/usr/bin/gawk -f
# Victorinox_02.awk
# gawk -f Victorinox_02.awk

/^<rdf:RDF xmlns:rdf="http:\/\/www\.w3\.org\/1999\/02\/22-rdf-syntax-ns#"$/,/^<\/rdf:RDF>$/{
	print;
}

