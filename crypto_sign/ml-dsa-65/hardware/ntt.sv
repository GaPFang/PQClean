module ntt # (
    parameter DataWidth = 32,
    parameter AddressWidth = 32,
    parameter [5:0] BFU_ARR_SIZE = 32
) (
    input  ntt_clk_i,
    input  ntt_rst_ni,

    input  ntt_req_i,
    input  ntt_we_i,
    input  [3:0] ntt_be_i,
    input  [31:0] ntt_addr_i,
    input  [31:0] ntt_wdata_i,
    output logic ntt_rvalid_o,
    output logic [31:0] ntt_rdata_o,
    output ntt_err_o,
    output ntt_intr_o
);

    // --- ROM for twiddles ---
    logic signed [31:0] twiddles [0:3][0:255];
    assign twiddles[0][0] = 1441;
    assign twiddles[0][1] = -758;
    assign twiddles[0][2] = -359;
    assign twiddles[0][3] = -1517;
    assign twiddles[0][4] = 1493;
    assign twiddles[0][5] = 1422;
    assign twiddles[0][6] = 287;
    assign twiddles[0][7] = 202;
    assign twiddles[0][8] = -171;
    assign twiddles[0][9] = 622;
    assign twiddles[0][10] = 1577;
    assign twiddles[0][11] = 182;
    assign twiddles[0][12] = 962;
    assign twiddles[0][13] = -1202;
    assign twiddles[0][14] = -1474;
    assign twiddles[0][15] = 1468;
    assign twiddles[0][16] = 573;
    assign twiddles[0][17] = -1325;
    assign twiddles[0][18] = 264;
    assign twiddles[0][19] = 383;
    assign twiddles[0][20] = -829;
    assign twiddles[0][21] = 1458;
    assign twiddles[0][22] = -1602;
    assign twiddles[0][23] = -130;
    assign twiddles[0][24] = -681;
    assign twiddles[0][25] = 1017;
    assign twiddles[0][26] = 732;
    assign twiddles[0][27] = 608;
    assign twiddles[0][28] = -1542;
    assign twiddles[0][29] = 411;
    assign twiddles[0][30] = -205;
    assign twiddles[0][31] = -1571;
    assign twiddles[0][32] = 1223;
    assign twiddles[0][33] = 652;
    assign twiddles[0][34] = -552;
    assign twiddles[0][35] = 1015;
    assign twiddles[0][36] = -1293;
    assign twiddles[0][37] = 1491;
    assign twiddles[0][38] = -282;
    assign twiddles[0][39] = -1544;
    assign twiddles[0][40] = 516;
    assign twiddles[0][41] = -8;
    assign twiddles[0][42] = -320;
    assign twiddles[0][43] = -666;
    assign twiddles[0][44] = -1618;
    assign twiddles[0][45] = -1162;
    assign twiddles[0][46] = 126;
    assign twiddles[0][47] = 1469;
    assign twiddles[0][48] = -853;
    assign twiddles[0][49] = -90;
    assign twiddles[0][50] = -271;
    assign twiddles[0][51] = 830;
    assign twiddles[0][52] = 107;
    assign twiddles[0][53] = -1421;
    assign twiddles[0][54] = -247;
    assign twiddles[0][55] = -951;
    assign twiddles[0][56] = -398;
    assign twiddles[0][57] = 961;
    assign twiddles[0][58] = -1508;
    assign twiddles[0][59] = -725;
    assign twiddles[0][60] = 448;
    assign twiddles[0][61] = -1065;
    assign twiddles[0][62] = 677;
    assign twiddles[0][63] = -1275;
    assign twiddles[0][64] = -1103;
    assign twiddles[0][65] = 430;
    assign twiddles[0][66] = 555;
    assign twiddles[0][67] = 843;
    assign twiddles[0][68] = -1251;
    assign twiddles[0][69] = 871;
    assign twiddles[0][70] = 1550;
    assign twiddles[0][71] = 105;
    assign twiddles[0][72] = 422;
    assign twiddles[0][73] = 587;
    assign twiddles[0][74] = 177;
    assign twiddles[0][75] = -235;
    assign twiddles[0][76] = -291;
    assign twiddles[0][77] = -460;
    assign twiddles[0][78] = 1574;
    assign twiddles[0][79] = 1653;
    assign twiddles[0][80] = -246;
    assign twiddles[0][81] = 778;
    assign twiddles[0][82] = 1159;
    assign twiddles[0][83] = -147;
    assign twiddles[0][84] = -777;
    assign twiddles[0][85] = 1483;
    assign twiddles[0][86] = -602;
    assign twiddles[0][87] = 1119;
    assign twiddles[0][88] = -1590;
    assign twiddles[0][89] = 644;
    assign twiddles[0][90] = -872;
    assign twiddles[0][91] = 349;
    assign twiddles[0][92] = 418;
    assign twiddles[0][93] = 329;
    assign twiddles[0][94] = -156;
    assign twiddles[0][95] = -75;
    assign twiddles[0][96] = 817;
    assign twiddles[0][97] = 1097;
    assign twiddles[0][98] = 603;
    assign twiddles[0][99] = 610;
    assign twiddles[0][100] = 1322;
    assign twiddles[0][101] = -1285;
    assign twiddles[0][102] = -1465;
    assign twiddles[0][103] = 384;
    assign twiddles[0][104] = -1215;
    assign twiddles[0][105] = -136;
    assign twiddles[0][106] = 1218;
    assign twiddles[0][107] = -1335;
    assign twiddles[0][108] = -874;
    assign twiddles[0][109] = 220;
    assign twiddles[0][110] = -1187;
    assign twiddles[0][111] = -1659;
    assign twiddles[0][112] = -1185;
    assign twiddles[0][113] = -1530;
    assign twiddles[0][114] = -1278;
    assign twiddles[0][115] = 794;
    assign twiddles[0][116] = -1510;
    assign twiddles[0][117] = -854;
    assign twiddles[0][118] = -870;
    assign twiddles[0][119] = 478;
    assign twiddles[0][120] = -108;
    assign twiddles[0][121] = -308;
    assign twiddles[0][122] = 996;
    assign twiddles[0][123] = 991;
    assign twiddles[0][124] = 958;
    assign twiddles[0][125] = -1460;
    assign twiddles[0][126] = 1522;
    assign twiddles[0][127] = 1628;
    assign twiddles[1][0] = 1441;
    assign twiddles[1][1] = -758;
    assign twiddles[1][2] = -1517;
    assign twiddles[1][3] = -359;
    assign twiddles[1][4] = 202;
    assign twiddles[1][5] = 287;
    assign twiddles[1][6] = 1422;
    assign twiddles[1][7] = 1493;
    assign twiddles[1][8] = 1468;
    assign twiddles[1][9] = -1474;
    assign twiddles[1][10] = -1202;
    assign twiddles[1][11] = 962;
    assign twiddles[1][12] = 182;
    assign twiddles[1][13] = 1577;
    assign twiddles[1][14] = 622;
    assign twiddles[1][15] = -171;
    assign twiddles[1][16] = -1571;
    assign twiddles[1][17] = -205;
    assign twiddles[1][18] = 411;
    assign twiddles[1][19] = -1542;
    assign twiddles[1][20] = 608;
    assign twiddles[1][21] = 732;
    assign twiddles[1][22] = 1017;
    assign twiddles[1][23] = -681;
    assign twiddles[1][24] = -130;
    assign twiddles[1][25] = -1602;
    assign twiddles[1][26] = 1458;
    assign twiddles[1][27] = -829;
    assign twiddles[1][28] = 383;
    assign twiddles[1][29] = 264;
    assign twiddles[1][30] = -1325;
    assign twiddles[1][31] = 573;
    assign twiddles[1][32] = -1275;
    assign twiddles[1][33] = 677;
    assign twiddles[1][34] = -1065;
    assign twiddles[1][35] = 448;
    assign twiddles[1][36] = -725;
    assign twiddles[1][37] = -1508;
    assign twiddles[1][38] = 961;
    assign twiddles[1][39] = -398;
    assign twiddles[1][40] = -951;
    assign twiddles[1][41] = -247;
    assign twiddles[1][42] = -1421;
    assign twiddles[1][43] = 107;
    assign twiddles[1][44] = 830;
    assign twiddles[1][45] = -271;
    assign twiddles[1][46] = -90;
    assign twiddles[1][47] = -853;
    assign twiddles[1][48] = 1469;
    assign twiddles[1][49] = 126;
    assign twiddles[1][50] = -1162;
    assign twiddles[1][51] = -1618;
    assign twiddles[1][52] = -666;
    assign twiddles[1][53] = -320;
    assign twiddles[1][54] = -8;
    assign twiddles[1][55] = 516;
    assign twiddles[1][56] = -1544;
    assign twiddles[1][57] = -282;
    assign twiddles[1][58] = 1491;
    assign twiddles[1][59] = -1293;
    assign twiddles[1][60] = 1015;
    assign twiddles[1][61] = -552;
    assign twiddles[1][62] = 652;
    assign twiddles[1][63] = 1223;
    assign twiddles[1][64] = 1628;
    assign twiddles[1][65] = 1522;
    assign twiddles[1][66] = -1460;
    assign twiddles[1][67] = 958;
    assign twiddles[1][68] = 991;
    assign twiddles[1][69] = 996;
    assign twiddles[1][70] = -308;
    assign twiddles[1][71] = -108;
    assign twiddles[1][72] = 478;
    assign twiddles[1][73] = -870;
    assign twiddles[1][74] = -854;
    assign twiddles[1][75] = -1510;
    assign twiddles[1][76] = 794;
    assign twiddles[1][77] = -1278;
    assign twiddles[1][78] = -1530;
    assign twiddles[1][79] = -1185;
    assign twiddles[1][80] = -1659;
    assign twiddles[1][81] = -1187;
    assign twiddles[1][82] = 220;
    assign twiddles[1][83] = -874;
    assign twiddles[1][84] = -1335;
    assign twiddles[1][85] = 1218;
    assign twiddles[1][86] = -136;
    assign twiddles[1][87] = -1215;
    assign twiddles[1][88] = 384;
    assign twiddles[1][89] = -1465;
    assign twiddles[1][90] = -1285;
    assign twiddles[1][91] = 1322;
    assign twiddles[1][92] = 610;
    assign twiddles[1][93] = 603;
    assign twiddles[1][94] = 1097;
    assign twiddles[1][95] = 817;
    assign twiddles[1][96] = -75;
    assign twiddles[1][97] = -156;
    assign twiddles[1][98] = 329;
    assign twiddles[1][99] = 418;
    assign twiddles[1][100] = 349;
    assign twiddles[1][101] = -872;
    assign twiddles[1][102] = 644;
    assign twiddles[1][103] = -1590;
    assign twiddles[1][104] = 1119;
    assign twiddles[1][105] = -602;
    assign twiddles[1][106] = 1483;
    assign twiddles[1][107] = -777;
    assign twiddles[1][108] = -147;
    assign twiddles[1][109] = 1159;
    assign twiddles[1][110] = 778;
    assign twiddles[1][111] = -246;
    assign twiddles[1][112] = 1653;
    assign twiddles[1][113] = 1574;
    assign twiddles[1][114] = -460;
    assign twiddles[1][115] = -291;
    assign twiddles[1][116] = -235;
    assign twiddles[1][117] = 177;
    assign twiddles[1][118] = 587;
    assign twiddles[1][119] = 422;
    assign twiddles[1][120] = 105;
    assign twiddles[1][121] = 1550;
    assign twiddles[1][122] = 871;
    assign twiddles[1][123] = -1251;
    assign twiddles[1][124] = 843;
    assign twiddles[1][125] = 555;
    assign twiddles[1][126] = 430;
    assign twiddles[1][127] = -1103;
    assign twiddles[2][0] = 41978;
    assign twiddles[2][1] = 25847;
    assign twiddles[2][2] = -2608894;
    assign twiddles[2][3] = -518909;
    assign twiddles[2][4] = 237124;
    assign twiddles[2][5] = -777960;
    assign twiddles[2][6] = -876248;
    assign twiddles[2][7] = 466468;
    assign twiddles[2][8] = 1826347;
    assign twiddles[2][9] = 2353451;
    assign twiddles[2][10] = -359251;
    assign twiddles[2][11] = -2091905;
    assign twiddles[2][12] = 3119733;
    assign twiddles[2][13] = -2884855;
    assign twiddles[2][14] = 3111497;
    assign twiddles[2][15] = 2680103;
    assign twiddles[2][16] = 2725464;
    assign twiddles[2][17] = 1024112;
    assign twiddles[2][18] = -1079900;
    assign twiddles[2][19] = 3585928;
    assign twiddles[2][20] = -549488;
    assign twiddles[2][21] = -1119584;
    assign twiddles[2][22] = 2619752;
    assign twiddles[2][23] = -2108549;
    assign twiddles[2][24] = -2118186;
    assign twiddles[2][25] = -3859737;
    assign twiddles[2][26] = -1399561;
    assign twiddles[2][27] = -3277672;
    assign twiddles[2][28] = 1757237;
    assign twiddles[2][29] = -19422;
    assign twiddles[2][30] = 4010497;
    assign twiddles[2][31] = 280005;
    assign twiddles[2][32] = 2706023;
    assign twiddles[2][33] = 95776;
    assign twiddles[2][34] = 3077325;
    assign twiddles[2][35] = 3530437;
    assign twiddles[2][36] = -1661693;
    assign twiddles[2][37] = -3592148;
    assign twiddles[2][38] = -2537516;
    assign twiddles[2][39] = 3915439;
    assign twiddles[2][40] = -3861115;
    assign twiddles[2][41] = -3043716;
    assign twiddles[2][42] = 3574422;
    assign twiddles[2][43] = -2867647;
    assign twiddles[2][44] = 3539968;
    assign twiddles[2][45] = -300467;
    assign twiddles[2][46] = 2348700;
    assign twiddles[2][47] = -539299;
    assign twiddles[2][48] = -1699267;
    assign twiddles[2][49] = -1643818;
    assign twiddles[2][50] = 3505694;
    assign twiddles[2][51] = -3821735;
    assign twiddles[2][52] = 3507263;
    assign twiddles[2][53] = -2140649;
    assign twiddles[2][54] = -1600420;
    assign twiddles[2][55] = 3699596;
    assign twiddles[2][56] = 811944;
    assign twiddles[2][57] = 531354;
    assign twiddles[2][58] = 954230;
    assign twiddles[2][59] = 3881043;
    assign twiddles[2][60] = 3900724;
    assign twiddles[2][61] = -2556880;
    assign twiddles[2][62] = 2071892;
    assign twiddles[2][63] = -2797779;
    assign twiddles[2][64] = -3930395;
    assign twiddles[2][65] = -1528703;
    assign twiddles[2][66] = -3677745;
    assign twiddles[2][67] = -3041255;
    assign twiddles[2][68] = -1452451;
    assign twiddles[2][69] = 3475950;
    assign twiddles[2][70] = 2176455;
    assign twiddles[2][71] = -1585221;
    assign twiddles[2][72] = -1257611;
    assign twiddles[2][73] = 1939314;
    assign twiddles[2][74] = -4083598;
    assign twiddles[2][75] = -1000202;
    assign twiddles[2][76] = -3190144;
    assign twiddles[2][77] = -3157330;
    assign twiddles[2][78] = -3632928;
    assign twiddles[2][79] = 126922;
    assign twiddles[2][80] = 3412210;
    assign twiddles[2][81] = -983419;
    assign twiddles[2][82] = 2147896;
    assign twiddles[2][83] = 2715295;
    assign twiddles[2][84] = -2967645;
    assign twiddles[2][85] = -3693493;
    assign twiddles[2][86] = -411027;
    assign twiddles[2][87] = -2477047;
    assign twiddles[2][88] = -671102;
    assign twiddles[2][89] = -1228525;
    assign twiddles[2][90] = -22981;
    assign twiddles[2][91] = -1308169;
    assign twiddles[2][92] = -381987;
    assign twiddles[2][93] = 1349076;
    assign twiddles[2][94] = 1852771;
    assign twiddles[2][95] = -1430430;
    assign twiddles[2][96] = -3343383;
    assign twiddles[2][97] = 264944;
    assign twiddles[2][98] = 508951;
    assign twiddles[2][99] = 3097992;
    assign twiddles[2][100] = 44288;
    assign twiddles[2][101] = -1100098;
    assign twiddles[2][102] = 904516;
    assign twiddles[2][103] = 3958618;
    assign twiddles[2][104] = -3724342;
    assign twiddles[2][105] = -8578;
    assign twiddles[2][106] = 1653064;
    assign twiddles[2][107] = -3249728;
    assign twiddles[2][108] = 2389356;
    assign twiddles[2][109] = -210977;
    assign twiddles[2][110] = 759969;
    assign twiddles[2][111] = -1316856;
    assign twiddles[2][112] = 189548;
    assign twiddles[2][113] = -3553272;
    assign twiddles[2][114] = 3159746;
    assign twiddles[2][115] = -1851402;
    assign twiddles[2][116] = -2409325;
    assign twiddles[2][117] = -177440;
    assign twiddles[2][118] = 1315589;
    assign twiddles[2][119] = 1341330;
    assign twiddles[2][120] = 1285669;
    assign twiddles[2][121] = -1584928;
    assign twiddles[2][122] = -812732;
    assign twiddles[2][123] = -1439742;
    assign twiddles[2][124] = -3019102;
    assign twiddles[2][125] = -3881060;
    assign twiddles[2][126] = -3628969;
    assign twiddles[2][127] = 3839961;
    assign twiddles[2][128] = 2091667;
    assign twiddles[2][129] = 3407706;
    assign twiddles[2][130] = 2316500;
    assign twiddles[2][131] = 3817976;
    assign twiddles[2][132] = -3342478;
    assign twiddles[2][133] = 2244091;
    assign twiddles[2][134] = -2446433;
    assign twiddles[2][135] = -3562462;
    assign twiddles[2][136] = 266997;
    assign twiddles[2][137] = 2434439;
    assign twiddles[2][138] = -1235728;
    assign twiddles[2][139] = 3513181;
    assign twiddles[2][140] = -3520352;
    assign twiddles[2][141] = -3759364;
    assign twiddles[2][142] = -1197226;
    assign twiddles[2][143] = -3193378;
    assign twiddles[2][144] = 900702;
    assign twiddles[2][145] = 1859098;
    assign twiddles[2][146] = 909542;
    assign twiddles[2][147] = 819034;
    assign twiddles[2][148] = 495491;
    assign twiddles[2][149] = -1613174;
    assign twiddles[2][150] = -43260;
    assign twiddles[2][151] = -522500;
    assign twiddles[2][152] = -655327;
    assign twiddles[2][153] = -3122442;
    assign twiddles[2][154] = 2031748;
    assign twiddles[2][155] = 3207046;
    assign twiddles[2][156] = -3556995;
    assign twiddles[2][157] = -525098;
    assign twiddles[2][158] = -768622;
    assign twiddles[2][159] = -3595838;
    assign twiddles[2][160] = 342297;
    assign twiddles[2][161] = 286988;
    assign twiddles[2][162] = -2437823;
    assign twiddles[2][163] = 4108315;
    assign twiddles[2][164] = 3437287;
    assign twiddles[2][165] = -3342277;
    assign twiddles[2][166] = 1735879;
    assign twiddles[2][167] = 203044;
    assign twiddles[2][168] = 2842341;
    assign twiddles[2][169] = 2691481;
    assign twiddles[2][170] = -2590150;
    assign twiddles[2][171] = 1265009;
    assign twiddles[2][172] = 4055324;
    assign twiddles[2][173] = 1247620;
    assign twiddles[2][174] = 2486353;
    assign twiddles[2][175] = 1595974;
    assign twiddles[2][176] = -3767016;
    assign twiddles[2][177] = 1250494;
    assign twiddles[2][178] = 2635921;
    assign twiddles[2][179] = -3548272;
    assign twiddles[2][180] = -2994039;
    assign twiddles[2][181] = 1869119;
    assign twiddles[2][182] = 1903435;
    assign twiddles[2][183] = -1050970;
    assign twiddles[2][184] = -1333058;
    assign twiddles[2][185] = 1237275;
    assign twiddles[2][186] = -3318210;
    assign twiddles[2][187] = -1430225;
    assign twiddles[2][188] = -451100;
    assign twiddles[2][189] = 1312455;
    assign twiddles[2][190] = 3306115;
    assign twiddles[2][191] = -1962642;
    assign twiddles[2][192] = -1279661;
    assign twiddles[2][193] = 1917081;
    assign twiddles[2][194] = -2546312;
    assign twiddles[2][195] = -1374803;
    assign twiddles[2][196] = 1500165;
    assign twiddles[2][197] = 777191;
    assign twiddles[2][198] = 2235880;
    assign twiddles[2][199] = 3406031;
    assign twiddles[2][200] = -542412;
    assign twiddles[2][201] = -2831860;
    assign twiddles[2][202] = -1671176;
    assign twiddles[2][203] = -1846953;
    assign twiddles[2][204] = -2584293;
    assign twiddles[2][205] = -3724270;
    assign twiddles[2][206] = 594136;
    assign twiddles[2][207] = -3776993;
    assign twiddles[2][208] = -2013608;
    assign twiddles[2][209] = 2432395;
    assign twiddles[2][210] = 2454455;
    assign twiddles[2][211] = -164721;
    assign twiddles[2][212] = 1957272;
    assign twiddles[2][213] = 3369112;
    assign twiddles[2][214] = 185531;
    assign twiddles[2][215] = -1207385;
    assign twiddles[2][216] = -3183426;
    assign twiddles[2][217] = 162844;
    assign twiddles[2][218] = 1616392;
    assign twiddles[2][219] = 3014001;
    assign twiddles[2][220] = 810149;
    assign twiddles[2][221] = 1652634;
    assign twiddles[2][222] = -3694233;
    assign twiddles[2][223] = -1799107;
    assign twiddles[2][224] = -3038916;
    assign twiddles[2][225] = 3523897;
    assign twiddles[2][226] = 3866901;
    assign twiddles[2][227] = 269760;
    assign twiddles[2][228] = 2213111;
    assign twiddles[2][229] = -975884;
    assign twiddles[2][230] = 1717735;
    assign twiddles[2][231] = 472078;
    assign twiddles[2][232] = -426683;
    assign twiddles[2][233] = 1723600;
    assign twiddles[2][234] = -1803090;
    assign twiddles[2][235] = 1910376;
    assign twiddles[2][236] = -1667432;
    assign twiddles[2][237] = -1104333;
    assign twiddles[2][238] = -260646;
    assign twiddles[2][239] = -3833893;
    assign twiddles[2][240] = -2939036;
    assign twiddles[2][241] = -2235985;
    assign twiddles[2][242] = -420899;
    assign twiddles[2][243] = -2286327;
    assign twiddles[2][244] = 183443;
    assign twiddles[2][245] = -976891;
    assign twiddles[2][246] = 1612842;
    assign twiddles[2][247] = -3545687;
    assign twiddles[2][248] = -554416;
    assign twiddles[2][249] = 3919660;
    assign twiddles[2][250] = -48306;
    assign twiddles[2][251] = -1362209;
    assign twiddles[2][252] = 3937738;
    assign twiddles[2][253] = 1400424;
    assign twiddles[2][254] = -846154;
    assign twiddles[2][255] = 1976782;
    assign twiddles[3][0] = 41978;
    assign twiddles[3][1] = 25847;
    assign twiddles[3][2] = -518909;
    assign twiddles[3][3] = -2608894;
    assign twiddles[3][4] = 466468;
    assign twiddles[3][5] = -876248;
    assign twiddles[3][6] = -777960;
    assign twiddles[3][7] = 237124;
    assign twiddles[3][8] = 2680103;
    assign twiddles[3][9] = 3111497;
    assign twiddles[3][10] = -2884855;
    assign twiddles[3][11] = 3119733;
    assign twiddles[3][12] = -2091905;
    assign twiddles[3][13] = -359251;
    assign twiddles[3][14] = 2353451;
    assign twiddles[3][15] = 1826347;
    assign twiddles[3][16] = 280005;
    assign twiddles[3][17] = 4010497;
    assign twiddles[3][18] = -19422;
    assign twiddles[3][19] = 1757237;
    assign twiddles[3][20] = -3277672;
    assign twiddles[3][21] = -1399561;
    assign twiddles[3][22] = -3859737;
    assign twiddles[3][23] = -2118186;
    assign twiddles[3][24] = -2108549;
    assign twiddles[3][25] = 2619752;
    assign twiddles[3][26] = -1119584;
    assign twiddles[3][27] = -549488;
    assign twiddles[3][28] = 3585928;
    assign twiddles[3][29] = -1079900;
    assign twiddles[3][30] = 1024112;
    assign twiddles[3][31] = 2725464;
    assign twiddles[3][32] = -2797779;
    assign twiddles[3][33] = 2071892;
    assign twiddles[3][34] = -2556880;
    assign twiddles[3][35] = 3900724;
    assign twiddles[3][36] = 3881043;
    assign twiddles[3][37] = 954230;
    assign twiddles[3][38] = 531354;
    assign twiddles[3][39] = 811944;
    assign twiddles[3][40] = 3699596;
    assign twiddles[3][41] = -1600420;
    assign twiddles[3][42] = -2140649;
    assign twiddles[3][43] = 3507263;
    assign twiddles[3][44] = -3821735;
    assign twiddles[3][45] = 3505694;
    assign twiddles[3][46] = -1643818;
    assign twiddles[3][47] = -1699267;
    assign twiddles[3][48] = -539299;
    assign twiddles[3][49] = 2348700;
    assign twiddles[3][50] = -300467;
    assign twiddles[3][51] = 3539968;
    assign twiddles[3][52] = -2867647;
    assign twiddles[3][53] = 3574422;
    assign twiddles[3][54] = -3043716;
    assign twiddles[3][55] = -3861115;
    assign twiddles[3][56] = 3915439;
    assign twiddles[3][57] = -2537516;
    assign twiddles[3][58] = -3592148;
    assign twiddles[3][59] = -1661693;
    assign twiddles[3][60] = 3530437;
    assign twiddles[3][61] = 3077325;
    assign twiddles[3][62] = 95776;
    assign twiddles[3][63] = 2706023;
    assign twiddles[3][64] = 3839961;
    assign twiddles[3][65] = -3628969;
    assign twiddles[3][66] = -3881060;
    assign twiddles[3][67] = -3019102;
    assign twiddles[3][68] = -1439742;
    assign twiddles[3][69] = -812732;
    assign twiddles[3][70] = -1584928;
    assign twiddles[3][71] = 1285669;
    assign twiddles[3][72] = 1341330;
    assign twiddles[3][73] = 1315589;
    assign twiddles[3][74] = -177440;
    assign twiddles[3][75] = -2409325;
    assign twiddles[3][76] = -1851402;
    assign twiddles[3][77] = 3159746;
    assign twiddles[3][78] = -3553272;
    assign twiddles[3][79] = 189548;
    assign twiddles[3][80] = -1316856;
    assign twiddles[3][81] = 759969;
    assign twiddles[3][82] = -210977;
    assign twiddles[3][83] = 2389356;
    assign twiddles[3][84] = -3249728;
    assign twiddles[3][85] = 1653064;
    assign twiddles[3][86] = -8578;
    assign twiddles[3][87] = -3724342;
    assign twiddles[3][88] = 3958618;
    assign twiddles[3][89] = 904516;
    assign twiddles[3][90] = -1100098;
    assign twiddles[3][91] = 44288;
    assign twiddles[3][92] = 3097992;
    assign twiddles[3][93] = 508951;
    assign twiddles[3][94] = 264944;
    assign twiddles[3][95] = -3343383;
    assign twiddles[3][96] = -1430430;
    assign twiddles[3][97] = 1852771;
    assign twiddles[3][98] = 1349076;
    assign twiddles[3][99] = -381987;
    assign twiddles[3][100] = -1308169;
    assign twiddles[3][101] = -22981;
    assign twiddles[3][102] = -1228525;
    assign twiddles[3][103] = -671102;
    assign twiddles[3][104] = -2477047;
    assign twiddles[3][105] = -411027;
    assign twiddles[3][106] = -3693493;
    assign twiddles[3][107] = -2967645;
    assign twiddles[3][108] = 2715295;
    assign twiddles[3][109] = 2147896;
    assign twiddles[3][110] = -983419;
    assign twiddles[3][111] = 3412210;
    assign twiddles[3][112] = 126922;
    assign twiddles[3][113] = -3632928;
    assign twiddles[3][114] = -3157330;
    assign twiddles[3][115] = -3190144;
    assign twiddles[3][116] = -1000202;
    assign twiddles[3][117] = -4083598;
    assign twiddles[3][118] = 1939314;
    assign twiddles[3][119] = -1257611;
    assign twiddles[3][120] = -1585221;
    assign twiddles[3][121] = 2176455;
    assign twiddles[3][122] = 3475950;
    assign twiddles[3][123] = -1452451;
    assign twiddles[3][124] = -3041255;
    assign twiddles[3][125] = -3677745;
    assign twiddles[3][126] = -1528703;
    assign twiddles[3][127] = -3930395;
    assign twiddles[3][128] = 1976782;
    assign twiddles[3][129] = -846154;
    assign twiddles[3][130] = 1400424;
    assign twiddles[3][131] = 3937738;
    assign twiddles[3][132] = -1362209;
    assign twiddles[3][133] = -48306;
    assign twiddles[3][134] = 3919660;
    assign twiddles[3][135] = -554416;
    assign twiddles[3][136] = -3545687;
    assign twiddles[3][137] = 1612842;
    assign twiddles[3][138] = -976891;
    assign twiddles[3][139] = 183443;
    assign twiddles[3][140] = -2286327;
    assign twiddles[3][141] = -420899;
    assign twiddles[3][142] = -2235985;
    assign twiddles[3][143] = -2939036;
    assign twiddles[3][144] = -3833893;
    assign twiddles[3][145] = -260646;
    assign twiddles[3][146] = -1104333;
    assign twiddles[3][147] = -1667432;
    assign twiddles[3][148] = 1910376;
    assign twiddles[3][149] = -1803090;
    assign twiddles[3][150] = 1723600;
    assign twiddles[3][151] = -426683;
    assign twiddles[3][152] = 472078;
    assign twiddles[3][153] = 1717735;
    assign twiddles[3][154] = -975884;
    assign twiddles[3][155] = 2213111;
    assign twiddles[3][156] = 269760;
    assign twiddles[3][157] = 3866901;
    assign twiddles[3][158] = 3523897;
    assign twiddles[3][159] = -3038916;
    assign twiddles[3][160] = -1799107;
    assign twiddles[3][161] = -3694233;
    assign twiddles[3][162] = 1652634;
    assign twiddles[3][163] = 810149;
    assign twiddles[3][164] = 3014001;
    assign twiddles[3][165] = 1616392;
    assign twiddles[3][166] = 162844;
    assign twiddles[3][167] = -3183426;
    assign twiddles[3][168] = -1207385;
    assign twiddles[3][169] = 185531;
    assign twiddles[3][170] = 3369112;
    assign twiddles[3][171] = 1957272;
    assign twiddles[3][172] = -164721;
    assign twiddles[3][173] = 2454455;
    assign twiddles[3][174] = 2432395;
    assign twiddles[3][175] = -2013608;
    assign twiddles[3][176] = -3776993;
    assign twiddles[3][177] = 594136;
    assign twiddles[3][178] = -3724270;
    assign twiddles[3][179] = -2584293;
    assign twiddles[3][180] = -1846953;
    assign twiddles[3][181] = -1671176;
    assign twiddles[3][182] = -2831860;
    assign twiddles[3][183] = -542412;
    assign twiddles[3][184] = 3406031;
    assign twiddles[3][185] = 2235880;
    assign twiddles[3][186] = 777191;
    assign twiddles[3][187] = 1500165;
    assign twiddles[3][188] = -1374803;
    assign twiddles[3][189] = -2546312;
    assign twiddles[3][190] = 1917081;
    assign twiddles[3][191] = -1279661;
    assign twiddles[3][192] = -1962642;
    assign twiddles[3][193] = 3306115;
    assign twiddles[3][194] = 1312455;
    assign twiddles[3][195] = -451100;
    assign twiddles[3][196] = -1430225;
    assign twiddles[3][197] = -3318210;
    assign twiddles[3][198] = 1237275;
    assign twiddles[3][199] = -1333058;
    assign twiddles[3][200] = -1050970;
    assign twiddles[3][201] = 1903435;
    assign twiddles[3][202] = 1869119;
    assign twiddles[3][203] = -2994039;
    assign twiddles[3][204] = -3548272;
    assign twiddles[3][205] = 2635921;
    assign twiddles[3][206] = 1250494;
    assign twiddles[3][207] = -3767016;
    assign twiddles[3][208] = 1595974;
    assign twiddles[3][209] = 2486353;
    assign twiddles[3][210] = 1247620;
    assign twiddles[3][211] = 4055324;
    assign twiddles[3][212] = 1265009;
    assign twiddles[3][213] = -2590150;
    assign twiddles[3][214] = 2691481;
    assign twiddles[3][215] = 2842341;
    assign twiddles[3][216] = 203044;
    assign twiddles[3][217] = 1735879;
    assign twiddles[3][218] = -3342277;
    assign twiddles[3][219] = 3437287;
    assign twiddles[3][220] = 4108315;
    assign twiddles[3][221] = -2437823;
    assign twiddles[3][222] = 286988;
    assign twiddles[3][223] = 342297;
    assign twiddles[3][224] = -3595838;
    assign twiddles[3][225] = -768622;
    assign twiddles[3][226] = -525098;
    assign twiddles[3][227] = -3556995;
    assign twiddles[3][228] = 3207046;
    assign twiddles[3][229] = 2031748;
    assign twiddles[3][230] = -3122442;
    assign twiddles[3][231] = -655327;
    assign twiddles[3][232] = -522500;
    assign twiddles[3][233] = -43260;
    assign twiddles[3][234] = -1613174;
    assign twiddles[3][235] = 495491;
    assign twiddles[3][236] = 819034;
    assign twiddles[3][237] = 909542;
    assign twiddles[3][238] = 1859098;
    assign twiddles[3][239] = 900702;
    assign twiddles[3][240] = -3193378;
    assign twiddles[3][241] = -1197226;
    assign twiddles[3][242] = -3759364;
    assign twiddles[3][243] = -3520352;
    assign twiddles[3][244] = 3513181;
    assign twiddles[3][245] = -1235728;
    assign twiddles[3][246] = 2434439;
    assign twiddles[3][247] = 266997;
    assign twiddles[3][248] = -3562462;
    assign twiddles[3][249] = -2446433;
    assign twiddles[3][250] = 2244091;
    assign twiddles[3][251] = -3342478;
    assign twiddles[3][252] = 3817976;
    assign twiddles[3][253] = 2316500;
    assign twiddles[3][254] = 3407706;
    assign twiddles[3][255] = 2091667;

    logic signed [2:0] banks [0:1][0:3];
    assign banks[0][0] = 3'd0;
    assign banks[0][1] = 3'd3;
    assign banks[0][2] = 3'd5;
    assign banks[0][3] = 3'd6;
    assign banks[1][0] = 3'd1;
    assign banks[1][1] = 3'd2;
    assign banks[1][2] = 3'd4;
    assign banks[1][3] = 3'd7;

    localparam [31:0] KYBER_N = 256; // Size of the NTT

    // --- Internal registers ---
    logic algo_r, algo_w;
    logic intt_r, intt_w;
    logic [1:0] twiddle_bank_r, twiddle_bank_w;
    logic [7:0] len_r, len_w;
    logic [2:0] stage_r, stage_w;
    logic signed [31:0] groups_r [0:7][0:BFU_ARR_SIZE-1], groups_w [0:7][0:BFU_ARR_SIZE-1];
    logic done_r, done_w;

    integer i, j;

    // FSM states
    localparam S_IDLE  = 0,
               S_COMP  = 1,
               S_STORE = 2,
               S_F     = 3,
               S_DONE  = 4;
    logic [2:0] state_r, state_w;

    // BFU_arr
    genvar gi;
    logic [31:0] BFU_arr_i_a [0:BFU_ARR_SIZE-1];
    logic [31:0] BFU_arr_i_b [0:BFU_ARR_SIZE-1];
    logic [31:0] BFU_arr_twiddle [0:BFU_ARR_SIZE-1];
    logic [31:0] BFU_arr_o_a [0:BFU_ARR_SIZE-1];
    logic [31:0] BFU_arr_o_b [0:BFU_ARR_SIZE-1];
    logic bfu_skip;
    logic [1:0] cnt_r, cnt_w;
    logic [31:0] twiddles_idx;
    logic [2:0] group_idx [0:1];

    logic [31:0] permute_intt_0_i_a [0:BFU_ARR_SIZE-1];
    logic [31:0] permute_intt_0_i_b [0:BFU_ARR_SIZE-1];
    logic [31:0] permute_intt_1_i_a [0:BFU_ARR_SIZE-1];
    logic [31:0] permute_intt_1_i_b [0:BFU_ARR_SIZE-1];

    PERMUTE_INTT #(
        .HALF_NUM_BFU(BFU_ARR_SIZE/2)
    ) permute_intt_inst_0 (
        .i_a(permute_intt_0_i_a),
        .i_b(permute_intt_0_i_b),
        .i_intt(intt_r),
        .i_permute(stage_r >= 2),
        .o_a(BFU_arr_i_a),
        .o_b(BFU_arr_i_b)
    );

    // PERMUTE_INTT #(
    //     .HALF_NUM_BFU(BFU_ARR_SIZE/2)
    // ) permute_intt_inst_1 (
    //     .i_a(permute_intt_1_i_a),
    //     .i_b(permute_intt_1_i_b),
    //     .i_intt(intt_r),
    //     .i_permute(stage_r == 6),
    //     .o_a(BFU_arr_i_a),
    //     .o_b(BFU_arr_i_b)
    // );

    generate
        for (gi = 0; gi < BFU_ARR_SIZE; gi = gi + 1) begin : BFU_arr
            BFU bfu_inst (
                .i_clk(ntt_clk_i),
                .i_intt(intt_r),
                .i_skip(bfu_skip),
                .i_algo(algo_r),
                .i_a(BFU_arr_i_a[gi]),
                .i_b(BFU_arr_i_b[gi]),
                .i_twiddle(BFU_arr_twiddle[gi]),
                .o_a(BFU_arr_o_a[gi]),
                .o_b(BFU_arr_o_b[gi])
            );
        end
    endgenerate

    logic [31:0] permute_ntt_0_o_a [0:BFU_ARR_SIZE-1];
    logic [31:0] permute_ntt_0_o_b [0:BFU_ARR_SIZE-1];
    logic [31:0] permute_ntt_1_o_a [0:BFU_ARR_SIZE-1];
    logic [31:0] permute_ntt_1_o_b [0:BFU_ARR_SIZE-1];

    PERMUTE_NTT #(
        .HALF_NUM_BFU(BFU_ARR_SIZE/2)
    ) permute_ntt_inst_0 (
        .i_a(BFU_arr_o_a),
        .i_b(BFU_arr_o_b),
        .i_intt(intt_r),
        .i_permute(stage_r >= 2),
        .o_a(permute_ntt_1_o_a),
        .o_b(permute_ntt_1_o_b)
    );

    // PERMUTE_NTT #(
    //     .HALF_NUM_BFU(BFU_ARR_SIZE/2)
    // ) permute_ntt_inst_1 (
    //     .i_a(permute_ntt_0_o_a),
    //     .i_b(permute_ntt_0_o_b),
    //     .i_intt(intt_r),
    //     .i_permute(stage_r == 6),
    //     .o_a(permute_ntt_1_o_a),
    //     .o_b(permute_ntt_1_o_b)
    // );

    always @(*) begin
        state_w = state_r;
        len_w = len_r;
        done_w = 0;
        cnt_w = cnt_r;
        algo_w = algo_r;
        intt_w = intt_r;
        twiddle_bank_w = twiddle_bank_r;
        bfu_skip = 0;
        for (i = 0; i < 8; i = i + 1) begin
            for (j = 0; j < 32; j = j + 1) begin
                groups_w[i][j] = groups_r[i][j];
            end
        end
        for (i = 0; i < BFU_ARR_SIZE; i = i + 1) begin
            permute_intt_0_i_a[i] = 0;
            permute_intt_0_i_b[i] = 0;
        end
        case (stage_r)
            0: begin
                group_idx[0] = banks[^cnt_r][cnt_r >> 1];
                group_idx[1] = banks[1^(^cnt_r)][(cnt_r >> 1) + 2];
            end
            1: begin
                group_idx[0] = banks[^cnt_r][(cnt_r >> 1) << 1];
                group_idx[1] = banks[1^(^cnt_r)][((cnt_r >> 1) << 1) + 1];
            end
            default: begin
                group_idx[0] = banks[^cnt_r][cnt_r];
                group_idx[1] = banks[1^(^cnt_r)][cnt_r];
            end
        endcase
        case (state_r)
            S_IDLE: begin
                len_w = len_r;
                done_w = 0;
                if (ntt_we_i) begin
                    if (ntt_addr_i[2]) begin // config
                        algo_w = ntt_wdata_i[1]; // 0: Kyber, 1: Dilithium
                        intt_w = ntt_wdata_i[0]; // 0: NTT,   1: INTT
                    end else begin           // data
                        len_w = len_r + 1;
                        groups_w[len_r[7:5]][len_r[4:0]] = ntt_wdata_i;
                        stage_w = intt_r ? 7 : 0;
                        cnt_w = 0;
                        if (len_w == 0) begin
                            state_w = S_COMP;
                            twiddle_bank_w = algo_r * 2 + intt_r; // 0: Kyber NTT, 1: Kyber INTT, 2: Dilithium NTT, 3: Dilithium NTT
                        end
                    end
                end
            end

            S_COMP: begin
                if (stage_r == 7 & ~algo_r) begin
                    bfu_skip = 1;
                end
                for (i = 0; i < BFU_ARR_SIZE; i = i + 1) begin
                    permute_intt_0_i_a[i] = groups_r[group_idx[0]][i];
                    permute_intt_0_i_b[i] = groups_r[group_idx[1]][i];
                end
                // twiddles_idx = (1 << stage_r) + ((stage_r < 2) ? (cnt_r >> (2 - stage_r)) : (cnt_r << (stage_r - 2)));
                twiddles_idx = (1 << stage_r) + ((cnt_r << stage_r) >> 2);
                for (i = 0; i < BFU_ARR_SIZE; i = i + 1) begin
                    BFU_arr_twiddle[i] = (stage_r < 3) ? twiddles[twiddle_bank_r][twiddles_idx] : twiddles[twiddle_bank_r][twiddles_idx + (((i << (7 - stage_r)) & 5'd31) >> (7 - stage_r))];
                end
                cnt_w = cnt_r + 1;
                if (cnt_r == 3) begin
                    state_w = S_STORE;
                end
            end

            S_STORE: begin
                if (stage_r == 7 & ~algo_r) begin
                    bfu_skip = 1;
                end
                for (i = 0; i < BFU_ARR_SIZE; i = i + 1) begin
                    groups_w[group_idx[0]][i] = permute_ntt_1_o_a[i];
                    groups_w[group_idx[1]][i] = permute_ntt_1_o_b[i];
                end
                cnt_w = cnt_r + 1;
                if (cnt_r == 3) begin
                    state_w = S_COMP;
                    if (intt_r) begin
                        stage_w = stage_r - 1;
                        if (stage_r == 0) begin
                            state_w = S_F;
                            stage_w = 0;
                            intt_w = 0;
                        end
                    end else begin
                        stage_w = stage_r + 1;
                        if (stage_r == 7) begin
                            state_w = S_DONE;
                            stage_w = 0;
                            intt_w = 0;
                        end
                    end
                end
            end

            S_F: begin
                if (~stage_r[1]) begin
                    for (i = 0; i < BFU_ARR_SIZE; i = i + 1) begin
                        permute_intt_0_i_b[i] = groups_r[{stage_r[0], cnt_r}][i];
                    end
                    for (i = 0; i < BFU_ARR_SIZE; i = i + 1) begin
                        BFU_arr_twiddle[i] = twiddles[twiddle_bank_r][0];
                    end
                end
                if (state_r[0] | stage_r[1]) begin
                    for (i = 0; i < BFU_ARR_SIZE; i = i + 1) begin
                        groups_w[{stage_r[1], cnt_r}][i] = BFU_arr_o_a[i];
                    end
                end
                cnt_w = cnt_r + 1;
                if (cnt_r == 3) begin
                    stage_w = stage_r + 1;
                    if (stage_r == 2) begin
                        state_w = S_DONE;
                    end
                end
            end

            S_DONE: begin
                ntt_rvalid_o = 1;
                ntt_rdata_o = groups_r[len_r[7:5]][len_r[4:0]];
                len_w = len_r + 1;
                if (len_w == 0) begin
                    state_w = S_IDLE;
                end
            end

            default: begin
                
            end
        endcase
    end

    always @(posedge ntt_clk_i or negedge ntt_rst_ni) begin
        if (!ntt_rst_ni) begin
            state_r <= S_IDLE;
            len_r <= 0;
            algo_r <= 0;
            intt_r <= 0;
            twiddle_bank_r <= 0;
            cnt_r <= 0;
            stage_r <= 0;
            done_r <= 0;
            for (i = 0; i < 8; i = i + 1) begin
                for (j = 0; j < 32; j = j + 1) begin
                    groups_r[i][j] <= 0;
                end
            end
        end else begin
            state_r <= state_w;
            len_r <= len_w;
            algo_r <= algo_w;
            intt_r <= intt_w;
            twiddle_bank_r <= twiddle_bank_w;
            cnt_r <= cnt_w;
            stage_r <= stage_w;
            done_r <= done_w;
            for (i = 0; i < 8; i = i + 1) begin
                for (j = 0; j < 32; j = j + 1) begin
                    groups_r[i][j] <= groups_w[i][j];
                end
            end
        end
    end

endmodule
