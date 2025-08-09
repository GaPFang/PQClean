module ntt (
    input  clk,
    input  rst,
    input  start,
    input  signed [15:0] r_in [0:255],
    output done,
    output logic signed [15:0] r_out [0:255]
);

    // --- ROM for zetas ---
    logic signed [15:0] zetas [0:127];
    initial begin
        zetas[0]  = -1044;  zetas[1]  =  -758;  zetas[2]  =  -359;  zetas[3]  = -1517;
        zetas[4]  =  1493;  zetas[5]  =  1422;  zetas[6]  =   287;  zetas[7]  =   202;
        zetas[8]  =  -171;  zetas[9]  =   622;  zetas[10] =  1577;  zetas[11] =   182;
        zetas[12] =   962;  zetas[13] = -1202;  zetas[14] = -1474;  zetas[15] =  1468;
        zetas[16] =   573;  zetas[17] = -1325;  zetas[18] =   264;  zetas[19] =   383;
        zetas[20] =  -829;  zetas[21] =  1458;  zetas[22] = -1602;  zetas[23] =  -130;
        zetas[24] =  -681;  zetas[25] =  1017;  zetas[26] =   732;  zetas[27] =   608;
        zetas[28] = -1542;  zetas[29] =   411;  zetas[30] =  -205;  zetas[31] = -1571;
        zetas[32] =  1223;  zetas[33] =   652;  zetas[34] =  -552;  zetas[35] =  1015;
        zetas[36] = -1293;  zetas[37] =  1491;  zetas[38] =  -282;  zetas[39] = -1544;
        zetas[40] =   516;  zetas[41] =    -8;  zetas[42] =  -320;  zetas[43] =  -666;
        zetas[44] = -1618;  zetas[45] = -1162;  zetas[46] =   126;  zetas[47] =  1469;
        zetas[48] =  -853;  zetas[49] =   -90;  zetas[50] =  -271;  zetas[51] =   830;
        zetas[52] =   107;  zetas[53] = -1421;  zetas[54] =  -247;  zetas[55] =  -951;
        zetas[56] =  -398;  zetas[57] =   961;  zetas[58] = -1508;  zetas[59] =  -725;
        zetas[60] =   448;  zetas[61] = -1065;  zetas[62] =   677;  zetas[63] = -1275;
        zetas[64] = -1103;  zetas[65] =   430;  zetas[66] =   555;  zetas[67] =   843;
        zetas[68] = -1251;  zetas[69] =   871;  zetas[70] =  1550;  zetas[71] =   105;
        zetas[72] =   422;  zetas[73] =   587;  zetas[74] =   177;  zetas[75] =  -235;
        zetas[76] =  -291;  zetas[77] =  -460;  zetas[78] =  1574;  zetas[79] =  1653;
        zetas[80] =  -246;  zetas[81] =   778;  zetas[82] =  1159;  zetas[83] =  -147;
        zetas[84] =  -777;  zetas[85] =  1483;  zetas[86] =  -602;  zetas[87] =  1119;
        zetas[88] = -1590;  zetas[89] =   644;  zetas[90] =  -872;  zetas[91] =   349;
        zetas[92] =   418;  zetas[93] =   329;  zetas[94] =  -156;  zetas[95] =   -75;
        zetas[96] =   817;  zetas[97] =  1097;  zetas[98] =   603;  zetas[99] =   610;
        zetas[100]=  1322;  zetas[101]= -1285;  zetas[102]= -1465;  zetas[103]=   384;
        zetas[104]= -1215;  zetas[105]=  -136;  zetas[106]=  1218;  zetas[107]= -1335;
        zetas[108]=  -874;  zetas[109]=   220;  zetas[110]= -1187;  zetas[111]= -1659;
        zetas[112]= -1185;  zetas[113]= -1530;  zetas[114]= -1278;  zetas[115]=   794;
        zetas[116]= -1510;  zetas[117]=  -854;  zetas[118]=  -870;  zetas[119]=   478;
        zetas[120]=  -108;  zetas[121]=  -308;  zetas[122]=   996;  zetas[123]=   991;
        zetas[124]=   958;  zetas[125]= -1460;  zetas[126]=  1522;  zetas[127]=  1628;
    end

    localparam [15:0] KYBER_N = 256; // Size of the NTT
    localparam signed [15:0] KYBER_Q = 3329; // Modulus for the NTT
    localparam signed [15:0] KYBER_Q_INV = -3327; // Inverse of KYBER_Q in the field

    // --- Internal registers ---
    logic [7:0] len_r, len_w;
    logic [8:0] start_idx_r, start_idx_w, start_idx_tmp;
    logic signed [15:0] zeta_r, zeta_w, t_r, t_w;
    logic signed [15:0] r_out_r [0:255], r_out_w [0:255];
    logic [7:0] j_r, j_w, k_r, k_w;
    logic done_r, done_w;

    integer i;

    // fqmul function
    function signed [15:0] fqmul;
        input signed [15:0] a;
        input signed [15:0] b;
        logic signed [31:0] a_times_b;
        logic signed [15:0] tmp1;
        logic signed [31:0] tmp2;
        begin
            a_times_b = a * b;
            tmp1 = a_times_b * KYBER_Q_INV;
            tmp2 = a_times_b - tmp1 * KYBER_Q;
            fqmul = tmp2 >>> 16;
        end
    endfunction

    // FSM states
    localparam S_IDLE  = 0,
               S_COMP = 1,
               S_DONE  = 2;
    logic [1:0] state_r, state_w;

    assign done = done_r;

    always @(*) begin
        state_w = state_r;
        len_w = len_r;
        start_idx_w = start_idx_r;
        start_idx_tmp = start_idx_r;
        j_w = j_r;
        k_w = k_r;
        zeta_w = zetas[k_w];
        done_w = 0;
        t_w = fqmul(zeta_w, r_out_r[start_idx_r + len_r]);
        for (i = 0; i < KYBER_N; i = i + 1) begin
            r_out[i] = r_out_r[i];
            r_out_w[i] = r_out_r[i];
        end
        case (state_r)
            S_IDLE: begin
                for (i = 0; i < KYBER_N; i = i + 1) begin
                    r_out_w[i] = r_in[i];
                end
                len_w = {1'b1, 7'b0};
                k_w = 1;
                done_w = 0;
                start_idx_w = 0;
                if (start) begin
                    state_w = S_COMP;
                end
            end

            S_COMP: begin
                r_out_w[start_idx_r + len_r] = r_out_r[start_idx_r] - t_w;
                r_out_w[start_idx_r] = r_out_r[start_idx_r] + t_w;

                j_w = j_r + 1;
                if (j_w >= len_r) begin
                    j_w = 0;
                    k_w = k_r + 1;
                    start_idx_tmp = start_idx_r + len_r;
                end
                start_idx_w = start_idx_tmp + 1;
                if (start_idx_w >= KYBER_N) begin
                    len_w = len_r >> 1;
                    if (len_r == 2) begin
                        state_w = S_DONE;
                    end else begin
                        start_idx_w = 0;
                    end
                end
            end

            S_DONE: begin
                done_w = 1;
                state_w = S_IDLE;
            end
        endcase
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state_r <= S_IDLE;
            len_r <= 0;
            start_idx_r <= 0;
            zeta_r <= 0;
            done_r <= 0;
            t_r <= 0;
            j_r <= 0;
            k_r <= 0;
            for (i = 0; i < KYBER_N; i = i + 1) begin
                r_out_r[i] <= 0;
            end
        end else begin
            state_r <= state_w;
            len_r <= len_w;
            start_idx_r <= start_idx_w;
            zeta_r <= zeta_w;
            done_r <= done_w;
            t_r <= t_w;
            j_r <= j_w;
            k_r <= k_w;
            for (i = 0; i < KYBER_N; i = i + 1) begin
                r_out_r[i] <= r_out_w[i];
            end
        end
    end

endmodule

