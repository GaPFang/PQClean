import re

data = r"""
twiddles[0][0]  =  1441;  twiddles[0][1]  =  -758;  twiddles[0][2]  =  -359;  twiddles[0][3]  = -1517;
        twiddles[0][4]  =  1493;  twiddles[0][5]  =  1422;  twiddles[0][6]  =   287;  twiddles[0][7]  =   202;
        twiddles[0][8]  =  -171;  twiddles[0][9]  =   622;  twiddles[0][10] =  1577;  twiddles[0][11] =   182;
        twiddles[0][12] =   962;  twiddles[0][13] = -1202;  twiddles[0][14] = -1474;  twiddles[0][15] =  1468;
        twiddles[0][16] =   573;  twiddles[0][17] = -1325;  twiddles[0][18] =   264;  twiddles[0][19] =   383;
        twiddles[0][20] =  -829;  twiddles[0][21] =  1458;  twiddles[0][22] = -1602;  twiddles[0][23] =  -130;
        twiddles[0][24] =  -681;  twiddles[0][25] =  1017;  twiddles[0][26] =   732;  twiddles[0][27] =   608;
        twiddles[0][28] = -1542;  twiddles[0][29] =   411;  twiddles[0][30] =  -205;  twiddles[0][31] = -1571;
        twiddles[0][32] =  1223;  twiddles[0][33] =   652;  twiddles[0][34] =  -552;  twiddles[0][35] =  1015;
        twiddles[0][36] = -1293;  twiddles[0][37] =  1491;  twiddles[0][38] =  -282;  twiddles[0][39] = -1544;
        twiddles[0][40] =   516;  twiddles[0][41] =    -8;  twiddles[0][42] =  -320;  twiddles[0][43] =  -666;
        twiddles[0][44] = -1618;  twiddles[0][45] = -1162;  twiddles[0][46] =   126;  twiddles[0][47] =  1469;
        twiddles[0][48] =  -853;  twiddles[0][49] =   -90;  twiddles[0][50] =  -271;  twiddles[0][51] =   830;
        twiddles[0][52] =   107;  twiddles[0][53] = -1421;  twiddles[0][54] =  -247;  twiddles[0][55] =  -951;
        twiddles[0][56] =  -398;  twiddles[0][57] =   961;  twiddles[0][58] = -1508;  twiddles[0][59] =  -725;
        twiddles[0][60] =   448;  twiddles[0][61] = -1065;  twiddles[0][62] =   677;  twiddles[0][63] = -1275;
        twiddles[0][64] = -1103;  twiddles[0][65] =   430;  twiddles[0][66] =   555;  twiddles[0][67] =   843;
        twiddles[0][68] = -1251;  twiddles[0][69] =   871;  twiddles[0][70] =  1550;  twiddles[0][71] =   105;
        twiddles[0][72] =   422;  twiddles[0][73] =   587;  twiddles[0][74] =   177;  twiddles[0][75] =  -235;
        twiddles[0][76] =  -291;  twiddles[0][77] =  -460;  twiddles[0][78] =  1574;  twiddles[0][79] =  1653;
        twiddles[0][80] =  -246;  twiddles[0][81] =   778;  twiddles[0][82] =  1159;  twiddles[0][83] =  -147;
        twiddles[0][84] =  -777;  twiddles[0][85] =  1483;  twiddles[0][86] =  -602;  twiddles[0][87] =  1119;
        twiddles[0][88] = -1590;  twiddles[0][89] =   644;  twiddles[0][90] =  -872;  twiddles[0][91] =   349;
        twiddles[0][92] =   418;  twiddles[0][93] =   329;  twiddles[0][94] =  -156;  twiddles[0][95] =   -75;
        twiddles[0][96] =   817;  twiddles[0][97] =  1097;  twiddles[0][98] =   603;  twiddles[0][99] =   610;
        twiddles[0][100]=  1322;  twiddles[0][101]= -1285;  twiddles[0][102]= -1465;  twiddles[0][103]=   384;
        twiddles[0][104]= -1215;  twiddles[0][105]=  -136;  twiddles[0][106]=  1218;  twiddles[0][107]= -1335;
        twiddles[0][108]=  -874;  twiddles[0][109]=   220;  twiddles[0][110]= -1187;  twiddles[0][111]= -1659;
        twiddles[0][112]= -1185;  twiddles[0][113]= -1530;  twiddles[0][114]= -1278;  twiddles[0][115]=   794;
        twiddles[0][116]= -1510;  twiddles[0][117]=  -854;  twiddles[0][118]=  -870;  twiddles[0][119]=   478;
        twiddles[0][120]=  -108;  twiddles[0][121]=  -308;  twiddles[0][122]=   996;  twiddles[0][123]=   991;
        twiddles[0][124]=   958;  twiddles[0][125]= -1460;  twiddles[0][126]=  1522;  twiddles[0][127]=  1628;

        // Second row
        twiddles[1][0]  =  1441;  twiddles[1][1]  =  -758;  twiddles[1][2]  = -1517;  twiddles[1][3]  =  -359;
        twiddles[1][4]  =   202;  twiddles[1][5]  =   287;  twiddles[1][6]  =  1422;  twiddles[1][7]  =  1493;
        twiddles[1][8]  =  1468;  twiddles[1][9]  = -1474;  twiddles[1][10] = -1202;  twiddles[1][11] =   962;
        twiddles[1][12] =   182;  twiddles[1][13] =  1577;  twiddles[1][14] =   622;  twiddles[1][15] =  -171;
        twiddles[1][16] = -1571;  twiddles[1][17] =  -205;  twiddles[1][18] =   411;  twiddles[1][19] = -1542;
        twiddles[1][20] =   608;  twiddles[1][21] =   732;  twiddles[1][22] =  1017;  twiddles[1][23] =  -681;
        twiddles[1][24] =  -130;  twiddles[1][25] = -1602;  twiddles[1][26] =  1458;  twiddles[1][27] =  -829;
        twiddles[1][28] =   383;  twiddles[1][29] =   264;  twiddles[1][30] = -1325;  twiddles[1][31] =   573;
        twiddles[1][32] = -1275;  twiddles[1][33] =   677;  twiddles[1][34] = -1065;  twiddles[1][35] =   448;
        twiddles[1][36] =  -725;  twiddles[1][37] = -1508;  twiddles[1][38] =   961;  twiddles[1][39] =  -398;
        twiddles[1][40] =  -951;  twiddles[1][41] =  -247;  twiddles[1][42] = -1421;  twiddles[1][43] =   107;
        twiddles[1][44] =   830;  twiddles[1][45] =  -271;  twiddles[1][46] =   -90;  twiddles[1][47] =  -853;
        twiddles[1][48] =  1469;  twiddles[1][49] =   126;  twiddles[1][50] = -1162;  twiddles[1][51] = -1618;
        twiddles[1][52] =  -666;  twiddles[1][53] =  -320;  twiddles[1][54] =    -8;  twiddles[1][55] =   516;
        twiddles[1][56] = -1544;  twiddles[1][57] =  -282;  twiddles[1][58] =  1491;  twiddles[1][59] = -1293;
        twiddles[1][60] =  1015;  twiddles[1][61] =  -552;  twiddles[1][62] =   652;  twiddles[1][63] =  1223;
        twiddles[1][64] =  1628;  twiddles[1][65] =  1522;  twiddles[1][66] = -1460;  twiddles[1][67] =   958;
        twiddles[1][68] =   991;  twiddles[1][69] =   996;  twiddles[1][70] =  -308;  twiddles[1][71] =  -108;
        twiddles[1][72] =   478;  twiddles[1][73] =  -870;  twiddles[1][74] =  -854;  twiddles[1][75] = -1510;
        twiddles[1][76] =   794;  twiddles[1][77] = -1278;  twiddles[1][78] = -1530;  twiddles[1][79] = -1185;
        twiddles[1][80] = -1659;  twiddles[1][81] = -1187;  twiddles[1][82] =   220;  twiddles[1][83] =  -874;
        twiddles[1][84] = -1335;  twiddles[1][85] =  1218;  twiddles[1][86] =  -136;  twiddles[1][87] = -1215;
        twiddles[1][88] =   384;  twiddles[1][89] = -1465;  twiddles[1][90] = -1285;  twiddles[1][91] =  1322;
        twiddles[1][92] =   610;  twiddles[1][93] =   603;  twiddles[1][94] =  1097;  twiddles[1][95] =   817;
        twiddles[1][96] =   -75;  twiddles[1][97] =  -156;  twiddles[1][98] =   329;  twiddles[1][99] =   418;
        twiddles[1][100]=   349;  twiddles[1][101]=  -872;  twiddles[1][102]=   644;  twiddles[1][103]= -1590;
        twiddles[1][104]=  1119;  twiddles[1][105]=  -602;  twiddles[1][106]=  1483;  twiddles[1][107]=  -777;
        twiddles[1][108]=  -147;  twiddles[1][109]=  1159;  twiddles[1][110]=   778;  twiddles[1][111]=  -246;
        twiddles[1][112]=  1653;  twiddles[1][113]=  1574;  twiddles[1][114]=  -460;  twiddles[1][115]=  -291;
        twiddles[1][116]=  -235;  twiddles[1][117]=   177;  twiddles[1][118]=   587;  twiddles[1][119]=   422;
        twiddles[1][120]=   105;  twiddles[1][121]=  1550;  twiddles[1][122]=   871;  twiddles[1][123]= -1251;
        twiddles[1][124]=   843;  twiddles[1][125]=   555;  twiddles[1][126]=   430;  twiddles[1][127]= -1103;

        twiddles[2][  0] =    41978; twiddles[2][  1] =    25847; twiddles[2][  2] = -2608894; twiddles[2][  3] =  -518909; twiddles[2][  4] =   237124; twiddles[2][  5] =  -777960; twiddles[2][  6] =  -876248; twiddles[2][  7] =   466468;
        twiddles[2][  8] =  1826347; twiddles[2][  9] =  2353451; twiddles[2][ 10] =  -359251; twiddles[2][ 11] = -2091905; twiddles[2][ 12] =  3119733; twiddles[2][ 13] = -2884855; twiddles[2][ 14] =  3111497; twiddles[2][ 15] =  2680103;
        twiddles[2][ 16] =  2725464; twiddles[2][ 17] =  1024112; twiddles[2][ 18] = -1079900; twiddles[2][ 19] =  3585928; twiddles[2][ 20] =  -549488; twiddles[2][ 21] = -1119584; twiddles[2][ 22] =  2619752; twiddles[2][ 23] = -2108549;
        twiddles[2][ 24] = -2118186; twiddles[2][ 25] = -3859737; twiddles[2][ 26] = -1399561; twiddles[2][ 27] = -3277672; twiddles[2][ 28] =  1757237; twiddles[2][ 29] =   -19422; twiddles[2][ 30] =  4010497; twiddles[2][ 31] =   280005;
        twiddles[2][ 32] =  2706023; twiddles[2][ 33] =    95776; twiddles[2][ 34] =  3077325; twiddles[2][ 35] =  3530437; twiddles[2][ 36] = -1661693; twiddles[2][ 37] = -3592148; twiddles[2][ 38] = -2537516; twiddles[2][ 39] =  3915439;
        twiddles[2][ 40] = -3861115; twiddles[2][ 41] = -3043716; twiddles[2][ 42] =  3574422; twiddles[2][ 43] = -2867647; twiddles[2][ 44] =  3539968; twiddles[2][ 45] =  -300467; twiddles[2][ 46] =  2348700; twiddles[2][ 47] =  -539299;
        twiddles[2][ 48] = -1699267; twiddles[2][ 49] = -1643818; twiddles[2][ 50] =  3505694; twiddles[2][ 51] = -3821735; twiddles[2][ 52] =  3507263; twiddles[2][ 53] = -2140649; twiddles[2][ 54] = -1600420; twiddles[2][ 55] =  3699596;
        twiddles[2][ 56] =   811944; twiddles[2][ 57] =   531354; twiddles[2][ 58] =   954230; twiddles[2][ 59] =  3881043; twiddles[2][ 60] =  3900724; twiddles[2][ 61] = -2556880; twiddles[2][ 62] =  2071892; twiddles[2][ 63] = -2797779;
        twiddles[2][ 64] = -3930395; twiddles[2][ 65] = -1528703; twiddles[2][ 66] = -3677745; twiddles[2][ 67] = -3041255; twiddles[2][ 68] = -1452451; twiddles[2][ 69] =  3475950; twiddles[2][ 70] =  2176455; twiddles[2][ 71] = -1585221;
        twiddles[2][ 72] = -1257611; twiddles[2][ 73] =  1939314; twiddles[2][ 74] = -4083598; twiddles[2][ 75] = -1000202; twiddles[2][ 76] = -3190144; twiddles[2][ 77] = -3157330; twiddles[2][ 78] = -3632928; twiddles[2][ 79] =   126922;
        twiddles[2][ 80] =  3412210; twiddles[2][ 81] =  -983419; twiddles[2][ 82] =  2147896; twiddles[2][ 83] =  2715295; twiddles[2][ 84] = -2967645; twiddles[2][ 85] = -3693493; twiddles[2][ 86] =  -411027; twiddles[2][ 87] = -2477047;
        twiddles[2][ 88] =  -671102; twiddles[2][ 89] = -1228525; twiddles[2][ 90] =   -22981; twiddles[2][ 91] = -1308169; twiddles[2][ 92] =  -381987; twiddles[2][ 93] =  1349076; twiddles[2][ 94] =  1852771; twiddles[2][ 95] = -1430430;
        twiddles[2][ 96] = -3343383; twiddles[2][ 97] =   264944; twiddles[2][ 98] =   508951; twiddles[2][ 99] =  3097992; twiddles[2][100] =    44288; twiddles[2][101] = -1100098; twiddles[2][102] =   904516; twiddles[2][103] =  3958618;
        twiddles[2][104] = -3724342; twiddles[2][105] =    -8578; twiddles[2][106] =  1653064; twiddles[2][107] = -3249728; twiddles[2][108] =  2389356; twiddles[2][109] =  -210977; twiddles[2][110] =   759969; twiddles[2][111] = -1316856;
        twiddles[2][112] =   189548; twiddles[2][113] = -3553272; twiddles[2][114] =  3159746; twiddles[2][115] = -1851402; twiddles[2][116] = -2409325; twiddles[2][117] =  -177440; twiddles[2][118] =  1315589; twiddles[2][119] =  1341330;
        twiddles[2][120] =  1285669; twiddles[2][121] = -1584928; twiddles[2][122] =  -812732; twiddles[2][123] = -1439742; twiddles[2][124] = -3019102; twiddles[2][125] = -3881060; twiddles[2][126] = -3628969; twiddles[2][127] =  3839961;
        twiddles[2][128] =  2091667; twiddles[2][129] =  3407706; twiddles[2][130] =  2316500; twiddles[2][131] =  3817976; twiddles[2][132] = -3342478; twiddles[2][133] =  2244091; twiddles[2][134] = -2446433; twiddles[2][135] = -3562462;
        twiddles[2][136] =   266997; twiddles[2][137] =  2434439; twiddles[2][138] = -1235728; twiddles[2][139] =  3513181; twiddles[2][140] = -3520352; twiddles[2][141] = -3759364; twiddles[2][142] = -1197226; twiddles[2][143] = -3193378;
        twiddles[2][144] =   900702; twiddles[2][145] =  1859098; twiddles[2][146] =   909542; twiddles[2][147] =   819034; twiddles[2][148] =   495491; twiddles[2][149] = -1613174; twiddles[2][150] =   -43260; twiddles[2][151] =  -522500;
        twiddles[2][152] =  -655327; twiddles[2][153] = -3122442; twiddles[2][154] =  2031748; twiddles[2][155] =  3207046; twiddles[2][156] = -3556995; twiddles[2][157] =  -525098; twiddles[2][158] =  -768622; twiddles[2][159] = -3595838;
        twiddles[2][160] =   342297; twiddles[2][161] =   286988; twiddles[2][162] = -2437823; twiddles[2][163] =  4108315; twiddles[2][164] =  3437287; twiddles[2][165] = -3342277; twiddles[2][166] =  1735879; twiddles[2][167] =   203044;
        twiddles[2][168] =  2842341; twiddles[2][169] =  2691481; twiddles[2][170] = -2590150; twiddles[2][171] =  1265009; twiddles[2][172] =  4055324; twiddles[2][173] =  1247620; twiddles[2][174] =  2486353; twiddles[2][175] =  1595974;
        twiddles[2][176] = -3767016; twiddles[2][177] =  1250494; twiddles[2][178] =  2635921; twiddles[2][179] = -3548272; twiddles[2][180] = -2994039; twiddles[2][181] =  1869119; twiddles[2][182] =  1903435; twiddles[2][183] = -1050970;
        twiddles[2][184] = -1333058; twiddles[2][185] =  1237275; twiddles[2][186] = -3318210; twiddles[2][187] = -1430225; twiddles[2][188] =  -451100; twiddles[2][189] =  1312455; twiddles[2][190] =  3306115; twiddles[2][191] = -1962642;
        twiddles[2][192] = -1279661; twiddles[2][193] =  1917081; twiddles[2][194] = -2546312; twiddles[2][195] = -1374803; twiddles[2][196] =  1500165; twiddles[2][197] =   777191; twiddles[2][198] =  2235880; twiddles[2][199] =  3406031;
        twiddles[2][200] =  -542412; twiddles[2][201] = -2831860; twiddles[2][202] = -1671176; twiddles[2][203] = -1846953; twiddles[2][204] = -2584293; twiddles[2][205] = -3724270; twiddles[2][206] =   594136; twiddles[2][207] = -3776993;
        twiddles[2][208] = -2013608; twiddles[2][209] =  2432395; twiddles[2][210] =  2454455; twiddles[2][211] =  -164721; twiddles[2][212] =  1957272; twiddles[2][213] =  3369112; twiddles[2][214] =   185531; twiddles[2][215] = -1207385;
        twiddles[2][216] = -3183426; twiddles[2][217] =   162844; twiddles[2][218] =  1616392; twiddles[2][219] =  3014001; twiddles[2][220] =   810149; twiddles[2][221] =  1652634; twiddles[2][222] = -3694233; twiddles[2][223] = -1799107;
        twiddles[2][224] = -3038916; twiddles[2][225] =  3523897; twiddles[2][226] =  3866901; twiddles[2][227] =   269760; twiddles[2][228] =  2213111; twiddles[2][229] =  -975884; twiddles[2][230] =  1717735; twiddles[2][231] =   472078;
        twiddles[2][232] =  -426683; twiddles[2][233] =  1723600; twiddles[2][234] = -1803090; twiddles[2][235] =  1910376; twiddles[2][236] = -1667432; twiddles[2][237] = -1104333; twiddles[2][238] =  -260646; twiddles[2][239] = -3833893;
        twiddles[2][240] = -2939036; twiddles[2][241] = -2235985; twiddles[2][242] =  -420899; twiddles[2][243] = -2286327; twiddles[2][244] =   183443; twiddles[2][245] =  -976891; twiddles[2][246] =  1612842; twiddles[2][247] = -3545687;
        twiddles[2][248] =  -554416; twiddles[2][249] =  3919660; twiddles[2][250] =   -48306; twiddles[2][251] = -1362209; twiddles[2][252] =  3937738; twiddles[2][253] =  1400424; twiddles[2][254] =  -846154; twiddles[2][255] =  1976782;

        twiddles[3][  0] =    41978; twiddles[3][  1] =    25847; twiddles[3][  2] =  -518909; twiddles[3][  3] = -2608894; twiddles[3][  4] =   466468; twiddles[3][  5] =  -876248; twiddles[3][  6] =  -777960; twiddles[3][  7] =   237124;
        twiddles[3][  8] =  2680103; twiddles[3][  9] =  3111497; twiddles[3][ 10] = -2884855; twiddles[3][ 11] =  3119733; twiddles[3][ 12] = -2091905; twiddles[3][ 13] =  -359251; twiddles[3][ 14] =  2353451; twiddles[3][ 15] =  1826347;
        twiddles[3][ 16] =   280005; twiddles[3][ 17] =  4010497; twiddles[3][ 18] =   -19422; twiddles[3][ 19] =  1757237; twiddles[3][ 20] = -3277672; twiddles[3][ 21] = -1399561; twiddles[3][ 22] = -3859737; twiddles[3][ 23] = -2118186;
        twiddles[3][ 24] = -2108549; twiddles[3][ 25] =  2619752; twiddles[3][ 26] = -1119584; twiddles[3][ 27] =  -549488; twiddles[3][ 28] =  3585928; twiddles[3][ 29] = -1079900; twiddles[3][ 30] =  1024112; twiddles[3][ 31] =  2725464;
        twiddles[3][ 32] = -2797779; twiddles[3][ 33] =  2071892; twiddles[3][ 34] = -2556880; twiddles[3][ 35] =  3900724; twiddles[3][ 36] =  3881043; twiddles[3][ 37] =   954230; twiddles[3][ 38] =   531354; twiddles[3][ 39] =   811944;
        twiddles[3][ 40] =  3699596; twiddles[3][ 41] = -1600420; twiddles[3][ 42] = -2140649; twiddles[3][ 43] =  3507263; twiddles[3][ 44] = -3821735; twiddles[3][ 45] =  3505694; twiddles[3][ 46] = -1643818; twiddles[3][ 47] = -1699267;
        twiddles[3][ 48] =  -539299; twiddles[3][ 49] =  2348700; twiddles[3][ 50] =  -300467; twiddles[3][ 51] =  3539968; twiddles[3][ 52] = -2867647; twiddles[3][ 53] =  3574422; twiddles[3][ 54] = -3043716; twiddles[3][ 55] = -3861115;
        twiddles[3][ 56] =  3915439; twiddles[3][ 57] = -2537516; twiddles[3][ 58] = -3592148; twiddles[3][ 59] = -1661693; twiddles[3][ 60] =  3530437; twiddles[3][ 61] =  3077325; twiddles[3][ 62] =    95776; twiddles[3][ 63] =  2706023;
        twiddles[3][ 64] =  3839961; twiddles[3][ 65] = -3628969; twiddles[3][ 66] = -3881060; twiddles[3][ 67] = -3019102; twiddles[3][ 68] = -1439742; twiddles[3][ 69] =  -812732; twiddles[3][ 70] = -1584928; twiddles[3][ 71] =  1285669;
        twiddles[3][ 72] =  1341330; twiddles[3][ 73] =  1315589; twiddles[3][ 74] =  -177440; twiddles[3][ 75] = -2409325; twiddles[3][ 76] = -1851402; twiddles[3][ 77] =  3159746; twiddles[3][ 78] = -3553272; twiddles[3][ 79] =   189548;
        twiddles[3][ 80] = -1316856; twiddles[3][ 81] =   759969; twiddles[3][ 82] =  -210977; twiddles[3][ 83] =  2389356; twiddles[3][ 84] = -3249728; twiddles[3][ 85] =  1653064; twiddles[3][ 86] =    -8578; twiddles[3][ 87] = -3724342;
        twiddles[3][ 88] =  3958618; twiddles[3][ 89] =   904516; twiddles[3][ 90] = -1100098; twiddles[3][ 91] =    44288; twiddles[3][ 92] =  3097992; twiddles[3][ 93] =   508951; twiddles[3][ 94] =   264944; twiddles[3][ 95] = -3343383;
        twiddles[3][ 96] = -1430430; twiddles[3][ 97] =  1852771; twiddles[3][ 98] =  1349076; twiddles[3][ 99] =  -381987; twiddles[3][100] = -1308169; twiddles[3][101] =   -22981; twiddles[3][102] = -1228525; twiddles[3][103] =  -671102;
        twiddles[3][104] = -2477047; twiddles[3][105] =  -411027; twiddles[3][106] = -3693493; twiddles[3][107] = -2967645; twiddles[3][108] =  2715295; twiddles[3][109] =  2147896; twiddles[3][110] =  -983419; twiddles[3][111] =  3412210;
        twiddles[3][112] =   126922; twiddles[3][113] = -3632928; twiddles[3][114] = -3157330; twiddles[3][115] = -3190144; twiddles[3][116] = -1000202; twiddles[3][117] = -4083598; twiddles[3][118] =  1939314; twiddles[3][119] = -1257611;
        twiddles[3][120] = -1585221; twiddles[3][121] =  2176455; twiddles[3][122] =  3475950; twiddles[3][123] = -1452451; twiddles[3][124] = -3041255; twiddles[3][125] = -3677745; twiddles[3][126] = -1528703; twiddles[3][127] = -3930395;
        twiddles[3][128] =  1976782; twiddles[3][129] =  -846154; twiddles[3][130] =  1400424; twiddles[3][131] =  3937738; twiddles[3][132] = -1362209; twiddles[3][133] =   -48306; twiddles[3][134] =  3919660; twiddles[3][135] =  -554416;
        twiddles[3][136] = -3545687; twiddles[3][137] =  1612842; twiddles[3][138] =  -976891; twiddles[3][139] =   183443; twiddles[3][140] = -2286327; twiddles[3][141] =  -420899; twiddles[3][142] = -2235985; twiddles[3][143] = -2939036;
        twiddles[3][144] = -3833893; twiddles[3][145] =  -260646; twiddles[3][146] = -1104333; twiddles[3][147] = -1667432; twiddles[3][148] =  1910376; twiddles[3][149] = -1803090; twiddles[3][150] =  1723600; twiddles[3][151] =  -426683;
        twiddles[3][152] =   472078; twiddles[3][153] =  1717735; twiddles[3][154] =  -975884; twiddles[3][155] =  2213111; twiddles[3][156] =   269760; twiddles[3][157] =  3866901; twiddles[3][158] =  3523897; twiddles[3][159] = -3038916;
        twiddles[3][160] = -1799107; twiddles[3][161] = -3694233; twiddles[3][162] =  1652634; twiddles[3][163] =   810149; twiddles[3][164] =  3014001; twiddles[3][165] =  1616392; twiddles[3][166] =   162844; twiddles[3][167] = -3183426;
        twiddles[3][168] = -1207385; twiddles[3][169] =   185531; twiddles[3][170] =  3369112; twiddles[3][171] =  1957272; twiddles[3][172] =  -164721; twiddles[3][173] =  2454455; twiddles[3][174] =  2432395; twiddles[3][175] = -2013608;
        twiddles[3][176] = -3776993; twiddles[3][177] =   594136; twiddles[3][178] = -3724270; twiddles[3][179] = -2584293; twiddles[3][180] = -1846953; twiddles[3][181] = -1671176; twiddles[3][182] = -2831860; twiddles[3][183] =  -542412;
        twiddles[3][184] =  3406031; twiddles[3][185] =  2235880; twiddles[3][186] =   777191; twiddles[3][187] =  1500165; twiddles[3][188] = -1374803; twiddles[3][189] = -2546312; twiddles[3][190] =  1917081; twiddles[3][191] = -1279661;
        twiddles[3][192] = -1962642; twiddles[3][193] =  3306115; twiddles[3][194] =  1312455; twiddles[3][195] =  -451100; twiddles[3][196] = -1430225; twiddles[3][197] = -3318210; twiddles[3][198] =  1237275; twiddles[3][199] = -1333058;
        twiddles[3][200] = -1050970; twiddles[3][201] =  1903435; twiddles[3][202] =  1869119; twiddles[3][203] = -2994039; twiddles[3][204] = -3548272; twiddles[3][205] =  2635921; twiddles[3][206] =  1250494; twiddles[3][207] = -3767016;
        twiddles[3][208] =  1595974; twiddles[3][209] =  2486353; twiddles[3][210] =  1247620; twiddles[3][211] =  4055324; twiddles[3][212] =  1265009; twiddles[3][213] = -2590150; twiddles[3][214] =  2691481; twiddles[3][215] =  2842341;
        twiddles[3][216] =   203044; twiddles[3][217] =  1735879; twiddles[3][218] = -3342277; twiddles[3][219] =  3437287; twiddles[3][220] =  4108315; twiddles[3][221] = -2437823; twiddles[3][222] =   286988; twiddles[3][223] =   342297;
        twiddles[3][224] = -3595838; twiddles[3][225] =  -768622; twiddles[3][226] =  -525098; twiddles[3][227] = -3556995; twiddles[3][228] =  3207046; twiddles[3][229] =  2031748; twiddles[3][230] = -3122442; twiddles[3][231] =  -655327;
        twiddles[3][232] =  -522500; twiddles[3][233] =   -43260; twiddles[3][234] = -1613174; twiddles[3][235] =   495491; twiddles[3][236] =   819034; twiddles[3][237] =   909542; twiddles[3][238] =  1859098; twiddles[3][239] =   900702;
        twiddles[3][240] = -3193378; twiddles[3][241] = -1197226; twiddles[3][242] = -3759364; twiddles[3][243] = -3520352; twiddles[3][244] =  3513181; twiddles[3][245] = -1235728; twiddles[3][246] =  2434439; twiddles[3][247] =   266997;
        twiddles[3][248] = -3562462; twiddles[3][249] = -2446433; twiddles[3][250] =  2244091; twiddles[3][251] = -3342478; twiddles[3][252] =  3817976; twiddles[3][253] =  2316500; twiddles[3][254] =  3407706; twiddles[3][255] =  2091667;
"""

# Regex to match: twiddles[row][col] = value;
pattern = re.compile(
    r"twiddles\[(\d+)\]\[\s*(\d+)\s*\]\s*=\s*(-?\d+);"
)

assignments = pattern.findall(data)

for row, col, val in assignments:
    print(f"assign twiddles[{row}][{col}] = {val};")
