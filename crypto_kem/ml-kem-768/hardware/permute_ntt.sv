module PERMUTE_NTT # (
    parameter HALF_NUM_BFU = 16
)(
    input  [15:0] i_a [0:HALF_NUM_BFU*2-1],
    input  [15:0] i_b [0:HALF_NUM_BFU*2-1],
    output logic [15:0] o_a [0:HALF_NUM_BFU*2-1],
    output logic [15:0] o_b [0:HALF_NUM_BFU*2-1]
);

    always_comb begin
        for (int i = 0; i < HALF_NUM_BFU; i = i + 1) begin
            o_a[i*2] = i_a[i];
            o_a[i*2+1] = i_b[i];
            o_b[i*2] = i_a[i+HALF_NUM_BFU];
            o_b[i*2+1] = i_b[i+HALF_NUM_BFU];
        end
    end

endmodule
