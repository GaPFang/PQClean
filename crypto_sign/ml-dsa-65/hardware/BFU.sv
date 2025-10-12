module BFU (
    input  i_clk,
    input  i_intt,
    input  i_skip,
    input  signed [31:0] i_a,
    input  signed [31:0] i_b,
    input  signed [31:0] i_twiddle,
    output logic signed [31:0] o_a,
    output logic signed [31:0] o_b
);

    // localparam signed [31:0] KYBER_Q = 3329; // Modulus for the NTT
    // localparam signed [31:0] KYBER_QINV = -3327; // Inverse of KYBER_Q in the field

    localparam signed [31:0] KYBER_Q = 8380417;
    localparam signed [31:0] KYBER_QINV = 58728449;

    logic signed [31:0] a0_r, a0_w, a1_r, a1_w, a2_r, a2_w, a3_r, a3_w;
    logic signed [31:0] b0_r, b0_w;
    logic signed [31:0] twiddle0_r, twiddle0_w;
    logic signed [63:0] b_twiddle1_r, b_twiddle1_w, b_twiddle2_r, b_twiddle2_w;
    logic signed [31:0] b_twiddle_QINV_r, b_twiddle_QINV_w;
    logic signed [31:0] reduced_r, reduced_w;

    always_comb begin
        if (i_skip) begin
            // cycle 0
            a0_w = i_a;
            b0_w = i_b;
            // cycle 1
            a1_w = a0_r;
            b_twiddle1_w = b0_r;
            // cycle 2
            a2_w = a1_r;
            b_twiddle2_w = b_twiddle1_r;
            // cycle 3
            a3_w = a2_r;
            reduced_w = b_twiddle2_r;
            // cycle 4
            o_a = a3_r;
            o_b = reduced_r;
        end else begin
            // cycle 0
            if (i_intt) begin
                a0_w = i_b + i_a;
                b0_w = i_b - i_a;
            end else begin
                a0_w = i_a;
                b0_w = i_b;
            end
            twiddle0_w = i_twiddle;
            // cycle 1
            a1_w = a0_r;
            b_twiddle1_w = b0_r * twiddle0_r;
            // cycle 2
            a2_w = a1_r;
            b_twiddle_QINV_w = b_twiddle1_r * KYBER_QINV;
            b_twiddle2_w = b_twiddle1_r;
            // cycle 3
            a3_w = a2_r;
            reduced_w = (b_twiddle2_r - b_twiddle_QINV_r * KYBER_Q) >>> 32;
            // cycle 4
            if (i_intt) begin
                o_a = a3_r;
                o_b = reduced_r;
            end else begin
                o_a = a3_r + reduced_r;
                o_b = a3_r - reduced_r;
            end
        end
        // end else begin
        //     // cycle 0
        //     if (i_intt) begin
        //         a0_w = i_b + i_a;
        //         b0_w = i_b - i_a;
        //     end else begin
        //         a0_w = i_a;
        //         b0_w = i_b;
        //     end
        //     twiddle0_w = i_twiddle;
        //     // cycle 1
        //     a1_w = (i_intt & (a0_r >= KYBER_Q)) ? (a0_r - KYBER_Q) : a0_r;
        //     b_twiddle1_w = b0_r * twiddle0_r;
        //     // cycle 2
        //     a2_w = (i_intt & (a1_r <= -KYBER_Q)) ? (a1_r + KYBER_Q) : a1_r;
        //     b_twiddle_QINV_w = b_twiddle1_r * KYBER_QINV;
        //     b_twiddle2_w = b_twiddle1_r;
        //     // cycle 3
        //     reduced_w = (b_twiddle2_r - b_twiddle_QINV_r * KYBER_Q) >>> 32;
        //     a3_w = a2_r;
        //     // cycle 4
        //     if (i_intt) begin
        //         o_a = a3_r;
        //         o_b = reduced_r;
        //     end else begin
        //         o_a = a3_r + reduced_r;
        //         o_b = a3_r - reduced_r;
        //     end
        // end
    end

    always_ff @(posedge i_clk) begin
        a0_r <= a0_w;
        a1_r <= a1_w;
        a2_r <= a2_w;
        a3_r <= a3_w;
        b0_r <= b0_w;
        twiddle0_r <= twiddle0_w;
        b_twiddle1_r <= b_twiddle1_w;
        b_twiddle2_r <= b_twiddle2_w;
        b_twiddle_QINV_r <= b_twiddle_QINV_w;
        reduced_r <= reduced_w;
    end


endmodule
