`timescale 1ns/1ps

module ntt_tb;

  // Parameters
  localparam [15:0] KYBER_Q = 3329;

  // Clock / reset / control
  logic clk;
  logic rst;
  logic ready;
  logic done;

  // Input / output arrays (SystemVerilog unpacked arrays)
  logic signed [15:0] r_in;
  wire signed [15:0] r_out [0:7][0:31];

  // Instantiate DUT (adjust instance name / port names if your module differs)
  ntt dut (
    .i_clk   (clk),
    .i_rst   (rst),
    .i_ready (ready),
    .i_intt  (1'b0),
    .i_data  (r_in),
    .o_valid (done),
    .o_data  (r_out)
  );

  // Clock generation: 10 ns period
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  // Test scenario
  integer i, j;
  initial begin
    // $fsdbDumpfile("ntt_tb.fsdb");
    // $fsdbDumpvars;
    // $fsdbDumpMDA;
    $dumpfile("ntt_tb.vcd");
    $dumpvars(0, ntt_tb);

    // Reset
    rst = 1;
    ready = 0;
    repeat (4) @(posedge clk);
    rst = 0;
    r_in = 0;
    @(posedge clk);
    ready = 1;
    // Step 1: Prepare input like C code: r[i] = i % KYBER_Q
    for (i = 0; i < 256; i = i + 1) begin
      r_in = (i % KYBER_Q); // fits in 16-bit signed
      @(posedge clk);
    end
    ready = 0;

    // Step 2: wait for done
    wait (done == 1);
    // give one clock to allow r_out to be stable if needed
    @(posedge clk);

    // Step 3: print results, 16 per line like C code
    $display("NTT result:");
    for (i = 0; i < 8; i = i + 1) begin
      for (j = 0; j < 32; j = j + 1) begin
      // sign-printed decimal with width 6 to mimic printf("%6d ")
        $write("%5d ", $signed(r_out[i][j]));
        if (((j + 1) % 16) == 0) $write("\n");
      end
    end
    $write("\n");

    // finish
    $display("Test finished.");
    #10;
    $finish;
  end

endmodule
