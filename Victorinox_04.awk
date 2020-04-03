#!/usr/bin/gawk -f
# Victorinox_04.awk
# gawk -f Victorinox_04.awk

/^<div class="gcse-searchbox-only"><\/div>$/,/^<div id="ldblog_related_articles_.*?">$/{
	print;
	next;
}

/^<div class="article-body-inner">$/,/^<div id="ldblog_related_articles_.*?">$/{
	print;
	next;
}

