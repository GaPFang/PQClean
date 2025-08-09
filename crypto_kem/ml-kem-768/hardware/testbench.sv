`timescale 1ns/1ps

module ntt_tb;

  // Parameters
  localparam [15:0] KYBER_Q = 3329;

  // Clock / reset / control
  logic clk;
  logic rst;
  logic start;
  logic done;

  // Input / output arrays (SystemVerilog unpacked arrays)
  logic signed [15:0] r_in  [0:255];
  wire signed [15:0] r_out [0:255];

  // Instantiate DUT (adjust instance name / port names if your module differs)
  ntt dut (
    .clk   (clk),
    .rst   (rst),
    .start (start),
    .r_in  (r_in),
    .done  (done),
    .r_out (r_out)
  );

  // Clock generation: 10 ns period
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  // Test scenario
  integer i;
  initial begin
    // $fsdbDumpfile("ntt_tb.fsdb");
    // $fsdbDumpvars;
    // $fsdbDumpMDA;
    $dumpfile("ntt_tb.vcd");
    $dumpvars(0, ntt_tb);

    // Reset
    rst = 1;
    start = 0;
    repeat (4) @(posedge clk);
    rst = 0;
    @(posedge clk);

    // Step 1: Prepare input like C code: r[i] = i % KYBER_Q
    for (i = 0; i < 256; i = i + 1) begin
      r_in[i] = (i % KYBER_Q); // fits in 16-bit signed
    end

    // small delay then start DUT
    @(posedge clk);
    start = 1;
    @(posedge clk);
    start = 0;

    // Step 2: wait for done
    wait (done == 1);
    // give one clock to allow r_out to be stable if needed
    @(posedge clk);

    // Step 3: print results, 16 per line like C code
    $display("NTT result:");
    for (i = 0; i < 256; i = i + 1) begin
      // sign-printed decimal with width 6 to mimic printf("%6d ")
      $write("%6d ", $signed(r_out[i]));
      if (((i + 1) % 16) == 0) $write("\n");
    end
    $write("\n");

    // finish
    $display("Test finished.");
    #10;
    $finish;
  end

endmodule
