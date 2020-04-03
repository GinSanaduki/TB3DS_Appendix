#!/usr/bin/gawk -f
# Victorinox_07.awk
# gawk -f Victorinox_07.awk

BEGIN{
	Line_01 = "";
	Line_02 = "";
	Line_03 = "";
	Line_04 = "\t";
	Line_05 = "";
	Line_06 = "";
}

# <b>☆令和[[:digit:]]年度***</b>
(NR == 1){
	Line_01 = $0"\t";
	next;
}

# ◎退職
# ◎退職
# ◎県立特別支援学校
# ◎県立高校
# 《但馬教育事務所》
# 《播磨西教育事務所》
# 《播磨東教育事務所》
# 《阪神教育事務所》
# ◎小学校
# ◎教委事務局
# ◎小学校
# ◎退職一般教職員
# ◎義務教育学校
# ◎中学校
# ◎小学校

(NR == 2){
	Line_02 = $0"\t";
	next;
}

/^<b>.*?<\/b>$/{
	mat = match($0,/^<b>〈.*?〉<\/b>$/);
	if(Line_03 == 0){
		Line_03 = $0"\t";
	} else {
		Line_04 = $0"\t";
	}
	next;
}

/^【/{
	Line_05 = $0"\t";
	next;
}

/^▽/{
	Line_06 = $0;
	print Line_01 Line_02 Line_03 Line_04 Line_05 Line_06;
	next;
}

