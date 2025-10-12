module PERMUTE_NTT # (
    parameter HALF_NUM_BFU = 16
)(
    input  [31:0] i_a [0:HALF_NUM_BFU*2-1],
    input  [31:0] i_b [0:HALF_NUM_BFU*2-1],
    input  i_intt,
    input  i_permute,
    output logic [31:0] o_a [0:HALF_NUM_BFU*2-1],
    output logic [31:0] o_b [0:HALF_NUM_BFU*2-1]
);

    always_comb begin
        if ((~i_intt) & i_permute) begin
            for (int i = 0; i < HALF_NUM_BFU; i = i + 1) begin
                o_a[i*2] = i_a[i];
                o_a[i*2+1] = i_b[i];
                o_b[i*2] = i_a[i+HALF_NUM_BFU];
                o_b[i*2+1] = i_b[i+HALF_NUM_BFU];
            end
        end else begin
            for (int i = 0; i < HALF_NUM_BFU * 2; i = i + 1) begin
                o_a[i] = i_a[i];
                o_b[i] = i_b[i];
            end
        end
    end

endmodule
