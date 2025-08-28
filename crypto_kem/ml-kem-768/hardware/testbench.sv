`timescale 1ns/1ps

module ntt_tb;

  // Parameters
  localparam [15:0] KYBER_Q = 3329;

  // Clock / reset / control
  logic clk;
  logic rst;
  logic ready;
  logic valid;

  // Input / output arrays (SystemVerilog unpacked arrays)
  logic signed [15:0] i_data;
  wire  signed [15:0] o_data;
  logic signed [15:0] r_out [0:255];

  // Instantiate DUT (adjust instance name / port names if your module differs)
  ntt dut (
    .i_clk   (clk),
    .i_rst   (rst),
    .i_ready (ready),
    .i_intt  (1'b1),
    .i_data  (i_data),
    .o_valid (valid),
    .o_data  (o_data)
  );

  // Clock generation: 10 ns period
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  // Test scenario
  integer i;
  initial begin
    $fsdbDumpfile("ntt_tb.fsdb");
    $fsdbDumpvars;
    $fsdbDumpMDA;
    // $dumpfile("ntt_tb.vcd");
    // $dumpvars(0, ntt_tb);

    // Reset
    rst = 1;
    ready = 0;
    repeat (4) @(posedge clk);
    rst = 0;
    i_data = 0;
    @(posedge clk);
    ready = 1;
    // Step 1: Prepare input like C code: r[i] = i % KYBER_Q
    for (i = 0; i < 256; i = i + 1) begin
      i_data = (i % KYBER_Q); // fits in 16-bit signed
      @(posedge clk);
    end
    ready = 0;

    // give one clock to allow o_data to be stable if needed
    @(posedge clk);

    i = 0;
    while (i < 256) begin
      @(negedge clk);
      if (valid) begin
        r_out[i] = o_data;
        i = i + 1;
      end
    end

    // Step 3: print results, 16 per line like C code
    $display("NTT result:");
    for (i = 0; i < 256; i = i + 1) begin
      // sign-printed decimal with width 6 to mimic printf("%6d ")
      $write("%5d ", $signed(r_out[i]));
      if (((i + 1) % 16) == 0) $write("\n");
    end
    $write("\n");

    // finish
    $display("Test finished.");
    #10;
    $finish;
  end

endmodule
