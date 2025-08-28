module PERMUTE_INTT # (
    parameter HALF_NUM_BFU = 16
)(
    input  [15:0] i_a [0:HALF_NUM_BFU*2-1],
    input  [15:0] i_b [0:HALF_NUM_BFU*2-1],
    input  i_intt,
    input  i_permute,
    output logic [15:0] o_a [0:HALF_NUM_BFU*2-1],
    output logic [15:0] o_b [0:HALF_NUM_BFU*2-1]
);

    always_comb begin
        if (i_intt & i_permute) begin
            for (int i = 0; i < HALF_NUM_BFU; i = i + 1) begin
                o_a[i] = i_a[i*2];
                o_a[i+HALF_NUM_BFU] = i_b[i*2];
                o_b[i] = i_a[i*2+1];
                o_b[i+HALF_NUM_BFU] = i_b[i*2+1];
            end
        end else begin
            for (int i = 0; i < HALF_NUM_BFU * 2; i = i + 1) begin
                o_a[i] = i_a[i];
                o_b[i] = i_b[i];
            end
        end
    end

endmodule
