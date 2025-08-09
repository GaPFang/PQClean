// void PQCLEAN_MLKEM768_CLEAN_ntt(int16_t r[256]) {
//     unsigned int len, start, j, k;
//     int16_t t, zeta;

//     k = 1;
//     for (len = 128; len >= 2; len >>= 1) {
//         for (start = 0; start < 256; start = j + len) {
//             zeta = PQCLEAN_MLKEM768_CLEAN_zetas[k++];
//             for (j = start; j < start + len; j++) {
//                 t = fqmul(zeta, r[j + len]);
//                 r[j + len] = r[j] - t;
//                 r[j] = r[j] + t;
//             }
//         }
//     }
// }

// int16_t fqmul(int16_t a, int16_t b) {
//     int16_t t;

//     t = (int16_t)a * b * QINV;
//     t = (a * b - (int32_t)t * KYBER_Q) >> 16;
//     return t;
// }

module ntt (
    input          clk,
    input          rst,
    input          start,
    input  signed [15:0] r_in [0:255],
    output reg signed [15:0] r_out [0:255],
    output          done
);

    // --- ROM for zetas ---
    localparam [15:0] zetas [0:127] = {
        -1044,  -758,  -359, -1517,  1493,  1422,   287,   202,
        -171,   622,  1577,   182,   962, -1202, -1474,  1468,
        573, -1325,   264,   383,  -829,  1458, -1602,  -130,
        -681,  1017,   732,   608, -1542,   411,  -205, -1571,
        1223,   652,  -552,  1015, -1293,  1491,  -282, -1544,
        516,    -8,  -320,  -666, -1618, -1162,   126,  1469,
        -853,   -90,  -271,   830,   107, -1421,  -247,  -951,
        -398,   961, -1508,  -725,   448, -1065,   677, -1275,
        -1103,   430,   555,   843, -1251,   871,  1550,   105,
        422,   587,   177,  -235,  -291,  -460,  1574,  1653,
        -246,   778,  1159,  -147,  -777,  1483,  -602,  1119,
        -1590,   644,  -872,   349,   418,   329,  -156,   -75,
        817,  1097,   603,   610,  1322, -1285, -1465,   384,
        -1215,  -136,  1218, -1335,  -874,   220, -1187, -1659,
        -1185, -1530, -1278,   794, -1510,  -854,  -870,   478,
        -108,  -308,   996,   991,   958, -1460,  1522,  1628
    };

    // --- Internal registers ---
    reg [7:0] len_r, len_w;
    reg [8:0] start_idx_r, start_idx_w;
    reg [8:0] j_r, j_w;
    reg [7:0] k_r, k_w;
    reg signed [15:0] zeta_r, zeta_w, t;
    reg signed [15:0] r_out_r [0:255], r_out_w [0:255];
    reg done_r, done_w;

    integer i, j, k;

    // fqmul function
    function signed [15:0] fqmul;
        input signed [15:0] a;
        input signed [15:0] b;
        reg signed [31:0] a_times_b;
        reg signed [31:0] tmp;
        begin
            a_times_b = a * b;
            tmp = a_times_b - $signed(a_times_b[15:0]) * (-3327) * 3329;
            fqmul = tmp >>> 16;
        end
    endfunction

    // FSM states
    localparam S_IDLE  = 0,
               S_LEN   = 1,
               S_START = 2,
               S_JLOOP = 3,
               S_DONE  = 4;
    reg [2:0] state_r, state_w;

    assign done = done_r;

    always @(*) begin
        state_w = S_IDLE;
        len_w = 0;
        start_idx_w = 0;
        j_w = 0;
        k_w = 0;
        zeta_w = 0;
        done_w = 0;
        for (i = 0; i < 256; i = i + 1) begin
            r_out_w[i] = 0;
            r_out[i] = r_out_r[i];
        end
        case (state_r)
            S_IDLE: begin
                r_out_w = r_in; // copy input array
                k_w = 1;
                len_w = 128;
                done_w = 0;
                if (start) begin
                    state_w = S_START;
                end
            end

            S_START: begin
                start_idx_w = 0;
                state_w = S_JLOOP;
                zeta_w = zetas[k_r];
                k_w = k_r + 1;
                j_w = 0;
            end

            S_JLOOP: begin
                t = fqmul(zeta_r, r_out[start_idx_r + len_r]);
                r_out_w[start_idx_r + len_r] = r_out_r[start_idx_r] - t;
                r_out_w[start_idx_r] = r_out_r[start_idx_r] + t;

                if (j_r + 1 < len_r) begin
                    j_w = j + 1;
                    start_idx_w = start_idx_r + 1;
                end else begin
                    start_idx_w = start_idx_r + len_r;
                    if (start_idx_r + len_r >= 256) begin
                        len_w = len_r >> 1;
                        if (len_r >= 2)
                            state_w = S_START;
                        else
                            state_w = S_DONE;
                    end else begin
                        state_w = S_START;
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
            j_r <= 0;
            k_r <= 0;
            zeta_r <= 0;
            done_r <= 0;
            for (i = 0; i < 256; i = i + 1) begin
                r_out_r[i] <= 0;
            end
        end else begin
            state_r <= state_w;
            len_r <= len_w;
            start_idx_r <= start_idx_w;
            j_r <= j_w;
            k_r <= k_w;
            zeta_r <= zeta_w;
            done_r <= done_w;
            for (i = 0; i < 256; i = i + 1) begin
                r_out_r[i] <= r_out_w[i];
            end
        end
    end

endmodule

