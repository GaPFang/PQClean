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
    logic signed [15:0] twiddles [0:127];
    initial begin
        twiddles[0]  = -1044;  twiddles[1]  =  -758;  twiddles[2]  =  -359;  twiddles[3]  = -1517;
        twiddles[4]  =  1493;  twiddles[5]  =  1422;  twiddles[6]  =   287;  twiddles[7]  =   202;
        twiddles[8]  =  -171;  twiddles[9]  =   622;  twiddles[10] =  1577;  twiddles[11] =   182;
        twiddles[12] =   962;  twiddles[13] = -1202;  twiddles[14] = -1474;  twiddles[15] =  1468;
        twiddles[16] =   573;  twiddles[17] = -1325;  twiddles[18] =   264;  twiddles[19] =   383;
        twiddles[20] =  -829;  twiddles[21] =  1458;  twiddles[22] = -1602;  twiddles[23] =  -130;
        twiddles[24] =  -681;  twiddles[25] =  1017;  twiddles[26] =   732;  twiddles[27] =   608;
        twiddles[28] = -1542;  twiddles[29] =   411;  twiddles[30] =  -205;  twiddles[31] = -1571;
        twiddles[32] =  1223;  twiddles[33] =   652;  twiddles[34] =  -552;  twiddles[35] =  1015;
        twiddles[36] = -1293;  twiddles[37] =  1491;  twiddles[38] =  -282;  twiddles[39] = -1544;
        twiddles[40] =   516;  twiddles[41] =    -8;  twiddles[42] =  -320;  twiddles[43] =  -666;
        twiddles[44] = -1618;  twiddles[45] = -1162;  twiddles[46] =   126;  twiddles[47] =  1469;
        twiddles[48] =  -853;  twiddles[49] =   -90;  twiddles[50] =  -271;  twiddles[51] =   830;
        twiddles[52] =   107;  twiddles[53] = -1421;  twiddles[54] =  -247;  twiddles[55] =  -951;
        twiddles[56] =  -398;  twiddles[57] =   961;  twiddles[58] = -1508;  twiddles[59] =  -725;
        twiddles[60] =   448;  twiddles[61] = -1065;  twiddles[62] =   677;  twiddles[63] = -1275;
        twiddles[64] = -1103;  twiddles[65] =   430;  twiddles[66] =   555;  twiddles[67] =   843;
        twiddles[68] = -1251;  twiddles[69] =   871;  twiddles[70] =  1550;  twiddles[71] =   105;
        twiddles[72] =   422;  twiddles[73] =   587;  twiddles[74] =   177;  twiddles[75] =  -235;
        twiddles[76] =  -291;  twiddles[77] =  -460;  twiddles[78] =  1574;  twiddles[79] =  1653;
        twiddles[80] =  -246;  twiddles[81] =   778;  twiddles[82] =  1159;  twiddles[83] =  -147;
        twiddles[84] =  -777;  twiddles[85] =  1483;  twiddles[86] =  -602;  twiddles[87] =  1119;
        twiddles[88] = -1590;  twiddles[89] =   644;  twiddles[90] =  -872;  twiddles[91] =   349;
        twiddles[92] =   418;  twiddles[93] =   329;  twiddles[94] =  -156;  twiddles[95] =   -75;
        twiddles[96] =   817;  twiddles[97] =  1097;  twiddles[98] =   603;  twiddles[99] =   610;
        twiddles[100]=  1322;  twiddles[101]= -1285;  twiddles[102]= -1465;  twiddles[103]=   384;
        twiddles[104]= -1215;  twiddles[105]=  -136;  twiddles[106]=  1218;  twiddles[107]= -1335;
        twiddles[108]=  -874;  twiddles[109]=   220;  twiddles[110]= -1187;  twiddles[111]= -1659;
        twiddles[112]= -1185;  twiddles[113]= -1530;  twiddles[114]= -1278;  twiddles[115]=   794;
        twiddles[116]= -1510;  twiddles[117]=  -854;  twiddles[118]=  -870;  twiddles[119]=   478;
        twiddles[120]=  -108;  twiddles[121]=  -308;  twiddles[122]=   996;  twiddles[123]=   991;
        twiddles[124]=   958;  twiddles[125]= -1460;  twiddles[126]=  1522;  twiddles[127]=  1628;
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

    generate
        for (gi = 0; gi < BFU_ARR_SIZE; gi = gi + 1) begin : BFU_arr
            BFU bfu_inst (
                .i_clk(i_clk),
                .i_intt(intt_r),
                .i_a(BFU_arr_a[gi]),
                .i_b(BFU_arr_b[gi]),
                .i_twiddle(BFU_arr_twiddle[gi]),
                .o_a(BFU_arr_o_a[gi]),
                .o_b(BFU_arr_o_b[gi])
            );
        end
    endgenerate

    logic [15:0] permute_ntt_1_o_a [0:BFU_ARR_SIZE-1];
    logic [15:0] permute_ntt_1_o_b [0:BFU_ARR_SIZE-1];
    logic [15:0] permute_ntt_2_o_a [0:BFU_ARR_SIZE-1];
    logic [15:0] permute_ntt_2_o_b [0:BFU_ARR_SIZE-1];

    PERMUTE_NTT #(
        .HALF_NUM_BFU(BFU_ARR_SIZE/2)
    ) permute_ntt_inst_1 (
        .i_a(BFU_arr_o_a),
        .i_b(BFU_arr_o_b),
        .o_a(permute_ntt_1_o_a),
        .o_b(permute_ntt_1_o_b)
    );

    PERMUTE_NTT #(
        .HALF_NUM_BFU(BFU_ARR_SIZE/2)
    ) permute_ntt_inst_2 (
        .i_a(permute_ntt_1_o_a),
        .i_b(permute_ntt_1_o_b),
        .o_a(permute_ntt_2_o_a),
        .o_b(permute_ntt_2_o_b)
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
                    stage_w = 0;
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
                    BFU_arr_twiddle[i] = (stage_r < 3) ? twiddles[twiddles_idx] : twiddles[twiddles_idx + (((i << (7 - stage_r)) & 5'd31) >> (7 - stage_r))];
                end
                cnt_w = cnt_r + 1;
                if (cnt_r == 3) begin
                    state_w = S_STORE;
                end
            end

            S_STORE: begin
                for (i = 0; i < BFU_ARR_SIZE; i = i + 1) begin
                    if (stage_r < 2) begin
                        groups_w[group_idx[0]][i] = BFU_arr_o_a[i];
                        groups_w[group_idx[1]][i] = BFU_arr_o_b[i];
                    end else if (stage_r == 6) begin
                        groups_w[group_idx[0]][i] = permute_ntt_2_o_a[i];
                        groups_w[group_idx[1]][i] = permute_ntt_2_o_b[i];
                    end else begin
                        groups_w[group_idx[0]][i] = permute_ntt_1_o_a[i];
                        groups_w[group_idx[1]][i] = permute_ntt_1_o_b[i];
                    end
                end
                cnt_w = cnt_r + 1;
                if (cnt_r == 3) begin
                    if (stage_r == 6) begin
                        stage_w = 0;
                        state_w = S_DONE;
                    end else begin
                        stage_w = stage_r + 1;
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
