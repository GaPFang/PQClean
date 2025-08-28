module ntt # (
    parameter [5:0] BFU_ARR_SIZE = 32 // Size of the BFU array
) (
    input  i_clk,
    input  i_rst,
    input  i_ready,
    input  i_intt, // intterse NTT flag
    input  signed [15:0] i_data,
    output o_valid,
    output logic signed [15:0] o_data [0:7][0:31]
);

    // --- ROM for twiddles ---
    logic signed [15:0] twiddles [0:1][0:127];
    initial begin
        // First row
        twiddles[0][0]  = -1044;  twiddles[0][1]  =  -758;  twiddles[0][2]  =  -359;  twiddles[0][3]  = -1517;
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
        twiddles[1][0]  = -1044;  twiddles[1][1]  =  -758;  twiddles[1][2]  = -1517;  twiddles[1][3]  =  -359;
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
    end

    logic signed [2:0] banks [0:1][0:3];
    initial begin
        banks[0][0] = 3'd0; banks[1][0] = 3'd1;
        banks[0][1] = 3'd3; banks[1][1] = 3'd2;
        banks[0][2] = 3'd5; banks[1][2] = 3'd4;
        banks[0][3] = 3'd6; banks[1][3] = 3'd7;
    end

    localparam [15:0] KYBER_N = 256; // Size of the NTT

    // --- Internal registers ---
    logic intt_r, intt_w;
    logic [7:0] len_r, len_w;
    logic [2:0] stage_r, stage_w;
    logic signed [15:0] groups_r [0:7][0:BFU_ARR_SIZE-1], groups_w [0:7][0:BFU_ARR_SIZE-1];
    logic done_r, done_w;

    integer i, j;

    // FSM states
    localparam S_IDLE  = 0,
               S_COMP  = 1,
               S_STORE = 2,
               S_DONE  = 3;
    logic [1:0] state_r, state_w;

    assign done = done_r;

    // BFU_arr
    genvar gi;
    logic [15:0] BFU_arr_a [0:BFU_ARR_SIZE-1];
    logic [15:0] BFU_arr_b [0:BFU_ARR_SIZE-1];
    logic [15:0] BFU_arr_twiddle [0:BFU_ARR_SIZE-1];
    logic [15:0] BFU_arr_o_a [0:BFU_ARR_SIZE-1];
    logic [15:0] BFU_arr_o_b [0:BFU_ARR_SIZE-1];

    logic [15:0] permute_intt_0_o_a [0:BFU_ARR_SIZE-1];
    logic [15:0] permute_intt_0_o_b [0:BFU_ARR_SIZE-1];
    logic [15:0] permute_intt_1_o_a [0:BFU_ARR_SIZE-1];
    logic [15:0] permute_intt_1_o_b [0:BFU_ARR_SIZE-1];

    PERMUTE_INTT #(
        .HALF_NUM_BFU(BFU_ARR_SIZE/2)
    ) permute_intt_inst_1 (
        .i_a(BFU_arr_a),
        .i_b(BFU_arr_b),
        .i_intt(intt_r),
        .i_permute(stage_r >= 2),
        .o_a(permute_intt_0_o_a),
        .o_b(permute_intt_0_o_b)
    );

    PERMUTE_INTT #(
        .HALF_NUM_BFU(BFU_ARR_SIZE/2)
    ) permute_intt_inst_2 (
        .i_a(permute_intt_0_o_a),
        .i_b(permute_intt_0_o_b),
        .i_intt(intt_r),
        .i_permute(stage_r == 6),
        .o_a(permute_intt_1_o_a),
        .o_b(permute_intt_1_o_b)
    );

    generate
        for (gi = 0; gi < BFU_ARR_SIZE; gi = gi + 1) begin : BFU_arr
            BFU bfu_inst (
                .i_clk(i_clk),
                .i_intt(intt_r),
                .i_a(permute_intt_1_o_a[gi]),
                .i_b(permute_intt_1_o_b[gi]),
                .i_twiddle(BFU_arr_twiddle[gi]),
                .o_a(BFU_arr_o_a[gi]),
                .o_b(BFU_arr_o_b[gi])
            );
        end
    endgenerate

    logic [15:0] permute_ntt_0_o_a [0:BFU_ARR_SIZE-1];
    logic [15:0] permute_ntt_0_o_b [0:BFU_ARR_SIZE-1];
    logic [15:0] permute_ntt_1_o_a [0:BFU_ARR_SIZE-1];
    logic [15:0] permute_ntt_1_o_b [0:BFU_ARR_SIZE-1];

    PERMUTE_NTT #(
        .HALF_NUM_BFU(BFU_ARR_SIZE/2)
    ) permute_ntt_inst_1 (
        .i_a(BFU_arr_o_a),
        .i_b(BFU_arr_o_b),
        .i_intt(intt_r),
        .i_permute(stage_r >= 2),
        .o_a(permute_ntt_0_o_a),
        .o_b(permute_ntt_0_o_b)
    );

    PERMUTE_NTT #(
        .HALF_NUM_BFU(BFU_ARR_SIZE/2)
    ) permute_ntt_inst_2 (
        .i_a(permute_ntt_0_o_a),
        .i_b(permute_ntt_0_o_b),
        .i_intt(intt_r),
        .i_permute(stage_r == 6),
        .o_a(permute_ntt_1_o_a),
        .o_b(permute_ntt_1_o_b)
    );

    logic [1:0] cnt_r, cnt_w;
    logic [15:0] twiddles_idx;
    logic [2:0] group_idx [0:1];

    assign o_valid = done_r;
    assign o_data = groups_r;

    always @(*) begin
        state_w = state_r;
        len_w = len_r;
        done_w = 0;
        cnt_w = cnt_r;
        for (i = 0; i < 8; i = i + 1) begin
            for (j = 0; j < 32; j = j + 1) begin
                groups_w[i][j] = groups_r[i][j];
            end
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
                intt_w = i_intt;
                done_w = 0;
                if (i_ready) begin
                    len_w = len_r + 1;
                    groups_w[len_r[7:5]][len_r[4:0]] = i_data;
                    stage_w = i_intt ? 6 : 0;
                    cnt_w = 0;
                    if (len_w == 0) begin
                        state_w = S_COMP;
                    end
                end
            end

            S_COMP: begin
                for (i = 0; i < BFU_ARR_SIZE; i = i + 1) begin
                    BFU_arr_a[i] = groups_r[group_idx[0]][i];
                    BFU_arr_b[i] = groups_r[group_idx[1]][i];
                end
                // twiddles_idx = (1 << stage_r) + ((stage_r < 2) ? (cnt_r >> (2 - stage_r)) : (cnt_r << (stage_r - 2)));
                twiddles_idx = (1 << stage_r) + ((cnt_r << stage_r) >> 2);
                for (i = 0; i < BFU_ARR_SIZE; i = i + 1) begin
                    BFU_arr_twiddle[i] = (stage_r < 3) ? twiddles[intt_r][twiddles_idx] : twiddles[intt_r][twiddles_idx + (((i << (7 - stage_r)) & 5'd31) >> (7 - stage_r))];
                end
                cnt_w = cnt_r + 1;
                if (cnt_r == 3) begin
                    state_w = S_STORE;
                end
            end

            S_STORE: begin
                for (i = 0; i < BFU_ARR_SIZE; i = i + 1) begin
                    groups_w[group_idx[0]][i] = permute_ntt_1_o_a[i];
                    groups_w[group_idx[1]][i] = permute_ntt_1_o_b[i];
                end
                cnt_w = cnt_r + 1;
                if (cnt_r == 3) begin
                    stage_w = intt_r ? stage_r - 1 : stage_r + 1;
                    if (stage_w == 7) begin
                        state_w = S_DONE;
                    end else begin
                        state_w = S_COMP;
                    end
                end
            end

            S_DONE: begin
                done_w = 1;
                state_w = S_IDLE;
            end
        endcase
    end

    always @(posedge i_clk or posedge i_rst) begin
        if (i_rst) begin
            state_r <= S_IDLE;
            len_r <= 0;
            intt_r <= 0;
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
            intt_r <= intt_w;
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
