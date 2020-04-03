#!/usr/bin/gawk -f
# Scraper.awk
# gawk -f Scraper.awk

BEGIN{
	Aria_01 = "兵庫県";
	Aria_02 = "神戸市";
	
	cmd = "echo \""Aria_01"\" | sh urlencode.sh";
	while(cmd | getline Aria_01_Encode){
		break;
	}
	close(cmd);
	cmd = "echo \""Aria_02"\" | sh urlencode.sh";
	while(cmd | getline Aria_02_Encode){
		break;
	}
	close(cmd);
	MainURL_01 = "http://teachers-transfer.blog.jp/archives/";
	MainURL_02 = ".html";
	URL_Aria_01 = MainURL_01 Aria_01_Encode MainURL_02;
	URL_Aria_02 = MainURL_01 Aria_02_Encode MainURL_02;
	# Connection_Check(URL_Aria_01, Aria_01);
	# Connection_Check(URL_Aria_02, Aria_02);
	Year = strftime("%Y",systime());
	LastYear = Year - 1;
	DC_DATE="dc:date=\\\""LastYear"-04";
	DC_DATE_NonEsc="dc:date=\""LastYear"-04";
	FirstPageCheck(URL_Aria_01, Aria_01);
	FirstPageCheck(URL_Aria_02, Aria_02);
	HTMLArraysCnt = 1;
	PageMax_Aria_01 = HTMLGet(URL_Aria_01, Aria_01);
	PageMax_Aria_02 = HTMLGet(URL_Aria_02, Aria_02);
	HTMLArraysCnt_Deux = 1;
	for(i in HTMLArrays){
		split(HTMLArrays[i],TempArrays,"\t");
		if(substr(TempArrays[3],1,16) != DC_DATE_NonEsc){
			sub("rdf:about=","",TempArrays[1]);
			gsub("\"","",TempArrays[1]);
			
			sub("dc:title=","",TempArrays[2]);
			gsub("\"","",TempArrays[2]);
			gsub("　","_",TempArrays[2]);
			gsub("・","_",TempArrays[2]);
			gsub("/","_",TempArrays[2]);
			gsub("（","(",TempArrays[2]);
			gsub("）",")",TempArrays[2]);
			
			# おそらく、サイト管理人の打ち間違いだと思うので
			gsub("０","0",TempArrays[2]);
			gsub("１","1",TempArrays[2]);
			gsub("２","2",TempArrays[2]);
			gsub("３","3",TempArrays[2]);
			gsub("４","4",TempArrays[2]);
			gsub("５","5",TempArrays[2]);
			gsub("６","6",TempArrays[2]);
			gsub("７","7",TempArrays[2]);
			gsub("８","8",TempArrays[2]);
			gsub("９","9",TempArrays[2]);
			
			HTMLArraysDeux_03 = "curl -s "TempArrays[1]" > \""TempArrays[2]".txt\"";
			HTMLArraysDeux[HTMLArraysCnt_Deux] = TempArrays[1]"\t"TempArrays[2]"\t"HTMLArraysDeux_03"\t"TempArrays[2]".txt";
			HTMLArraysCnt_Deux++;
		}
		delete TempArrays;
	}
	delete HTMLArrays;
	if(HTMLArraysCnt_Deux < 2){
		exit 1;
	}
	for(i in HTMLArraysDeux){
		split(HTMLArraysDeux[i],TempArrays,"\t");
		EXEC(TempArrays[3]);
		SLEEP();
		delete TempArrays;
	}
	
	HTMLArraysDeux_CMD_02 = "gawk -f Victorinox_01.awk";
	HTMLArraysDeux_CMD_03 = "gawk -f Victorinox_04.awk";
	HTMLArraysDeux_CMD_04 = "sed \047$d\047";
	HTMLArraysDeux_CMD_05 = HTMLArraysDeux_CMD_04;
	HTMLArraysDeux_CMD_06 = "gawk -f Victorinox_04_02.awk";
	HTMLArraysDeux_CMD_07 = "gawk -f Victorinox_05.awk";
	HTMLArraysDeux_CMD_08 = "fgrep -v \"<br/>\"";
	HTMLArraysDeux_CMD_09 = "grep -e \047^<b>\047 -e \047^【\047 -e \047^▽\047";
	HTMLArraysDeux_CMD_10 = "gawk -f Victorinox_05_02.awk";
	HTMLArraysDeux_CMD_11 = "gawk -f Victorinox_06.awk";
	HTMLArraysDeux_CMD_12 = HTMLArraysDeux_CMD_07;
	HTMLArraysDeux_CMD_13 = "gawk -f Victorinox_07.awk";
	HTMLArraysDeux_CMD_14 = "gawk -f Victorinox_08.awk";
	
	HTMLArraysCntTrois = 1;
	for(i in HTMLArraysDeux){
		split(HTMLArraysDeux[i],TempArrays,"\t");
		HTMLArraysDeux_CMD_01 = "cat \""TempArrays[4]"\"";
		HTMLArraysDeux_CMD_01_04 = HTMLArraysDeux_CMD_01" | "HTMLArraysDeux_CMD_02" | "HTMLArraysDeux_CMD_03" | "HTMLArraysDeux_CMD_04;
		HTMLArraysDeux_CMD_05_08 = HTMLArraysDeux_CMD_05" | "HTMLArraysDeux_CMD_06" | "HTMLArraysDeux_CMD_07" | "HTMLArraysDeux_CMD_08;
		HTMLArraysDeux_CMD_09_12 = HTMLArraysDeux_CMD_09" | "HTMLArraysDeux_CMD_10" | "HTMLArraysDeux_CMD_11" | "HTMLArraysDeux_CMD_12;
		HTMLArraysDeux_CMD_13_14 = HTMLArraysDeux_CMD_13" | "HTMLArraysDeux_CMD_14;
		HTMLArraysDeux_CMD = HTMLArraysDeux_CMD_01_04" | "HTMLArraysDeux_CMD_05_08" | "HTMLArraysDeux_CMD_09_12" | "HTMLArraysDeux_CMD_13_14;
		esc = "";
		print HTMLArraysDeux_CMD;
		while(HTMLArraysDeux_CMD | getline esc){
			HTMLArraysTrois[HTMLArraysCntTrois] = esc;
			HTMLArraysCntTrois++;
		}
		close(HTMLArraysDeux_CMD);
		delete TempArrays;
	}
	print "HTMLArraysTrois : "length(HTMLArraysTrois);
	ResultTSV = "Result_"strftime("%Y%m%d_%H%M%S",systime())".tsv";
	for(i in HTMLArraysTrois){
		print HTMLArraysTrois[i] > ResultTSV;
	}
}

# 接続チェック
function Connection_Check(CC_URL, CC_Aria, CC_cmd, CC_RetCode){
	CC_cmd = "curl -s -I "CC_URL" | fgrep -q \"HTTP/1.1 200 OK\"";
	CC_RetCode = system(CC_cmd);
	if(CC_RetCode != 0){
		print "Connection Failed. : "CC_Aria", "CC_URL;
		exit 99;
	}
	SLEEP();
}

function SLEEP(SleepTime){
	SleepTime = int(SleepTime + 0);
	if(SleepTime < 1){
		SleepTime = 3;
	}
	SLEEP_CMD = "sleep "SleepTime;
	EXEC(SLEEP_CMD);
}

# 1ページ目に前年度のデータが含まれていないかを確認
function FirstPageCheck(PC_URL, PC_Aria, PC_cmd, PC_RetCode){
	PC_cmd = "curl -s "PC_URL" | fgrep -q \""DC_DATE"\"";
	PC_RetCode = system(PC_cmd);
	close(PC_cmd);
	if(PC_RetCode == 0){
		print "The previous year's data is on the first page. : "PC_Aria", "PC_URL;
		exit 99;
	}
	SLEEP();
}

function PageCheck(PC_URL, PC_cmd, PC_RetCode){
	PC_cmd = "curl -s "PC_URL" | fgrep -q \""DC_DATE"\"";
	PC_RetCode = system(PC_cmd);
	close(PC_cmd);
	SLEEP();
	return PC_RetCode;
}

# 昨年の記事データが出現するまで、ページを取得し続ける
function HTMLGet(HG_URL, HG_Aria, HG_cmd, HG_RetCode, HG_Cnt, HG_URL_Temp){
	HG_Cnt = 1;
	HG_Pre();
	while(1){
		HG_RetCode = 1;
		HG_URL_Temp = "";
		HG_OutPage = "";
		HG_OutPage = HG_Aria"_Page_"HG_Cnt".txt";
		if(HG_Cnt == 1){
			HG_cmd_01 = "curl -s "HG_URL
		} else {
			HG_URL_Temp = HG_URL"?p="HG_Cnt;
			Connection_Check(HG_URL_Temp, HG_Aria);
			HG_RetCode = PageCheck(HG_URL_Temp);
			HG_cmd_01 = "curl -s "HG_URL_Temp
		}
		HG_cmd_01_05 = HG_cmd_01" | "HG_cmd_02" | "HG_cmd_03" | "HG_cmd_04" | "HG_cmd_05;
		HG_cmd_06_10 = HG_cmd_06" | "HG_cmd_07" | "HG_cmd_08" | "HG_cmd_09" | "HG_cmd_10;
		HG_cmd_11_14 = HG_cmd_11" | "HG_cmd_12" | "HG_cmd_13" | "HG_cmd_14;
		HG_cmd = HG_cmd_01_05" | "HG_cmd_06_10" | "HG_cmd_11_14;
		esc = "";
		while(HG_cmd | getline esc){
			HTMLArrays[HTMLArraysCnt] = esc;
			HTMLArraysCnt++;
			esc = "";
		}
		close(HG_cmd);
		SLEEP();
		if(HG_RetCode == 0){
			return HG_Cnt;
		}
		HG_Cnt++;
	}
}

function EXEC(EXEC_CMD){
	system(EXEC_CMD);
	close(EXEC_CMD);
}

function HG_Pre(){
	HG_cmd_02 = "gawk -f Victorinox_01.awk";
	HG_cmd_03 = "gawk -f Victorinox_02.awk";
	HG_cmd_04 = "fgrep -v \"<rdf:RDF xmlns:rdf=\"";
	HG_cmd_05 = "fgrep -v \"xmlns:trackback=\"";
	HG_cmd_06 = "fgrep -v \"xmlns:dc=\"";
	HG_cmd_07 = "fgrep -v \"<rdf:Description\"";
	HG_cmd_08 = "fgrep -v \"trackback:ping=\"";
	HG_cmd_09 = "fgrep -v \"dc:identifier=\"";
	HG_cmd_10 = "fgrep -v \"dc:subject\"";
	HG_cmd_11 = "fgrep -v \"dc:description=\"";
	HG_cmd_12 = "fgrep -v \"dc:creator=\"";
	HG_cmd_13 = "fgrep -v \"</rdf:RDF>\"";
	HG_cmd_14 = "gawk -f Victorinox_03.awk";
}

