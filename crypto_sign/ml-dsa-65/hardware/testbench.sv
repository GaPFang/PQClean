`timescale 1ns/1ps

module ntt_tb;

  // Parameters
  localparam [31:0] KYBER_Q = 3329;

  // Clock / reset / control
  logic clk;
  logic rst;
  logic ready;
  logic valid;
  logic tmp_valid;
  logic signed [31:0] tmp_data;

  // Input / output arrays (SystemVerilog unpacked arrays)
  logic signed [31:0] i_data;
  logic signed [31:0] o_data;
  logic signed [31:0] r_out [0:255];

  // Instantiate DUT (adjust instance name / port names if your module differs)
  ntt dut_ntt (
    .i_clk   (clk),
    .i_rst   (rst),
    .i_ready (ready),
    .i_algo  (1'b1),
    .i_intt  (1'b0),
    .i_data  (i_data),
    .o_valid (tmp_valid),
    .o_data  (tmp_data)
  );

  ntt dut_intt (
    .i_clk   (clk),
    .i_rst   (rst),
    .i_ready (tmp_valid),
    .i_algo  (1'b1),
    .i_intt  (1'b1),
    .i_data  (tmp_data),
    .o_valid (valid),
    .o_data  (o_data)
  );

  integer cycles;

  // Clock generation: 10 ns period
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  initial begin
    while (1) begin
      @(posedge clk);
      cycles = cycles + 1;
    end
  end

  // Test scenario
  logic [31:0] i;
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
    cycles = 0;
    @(posedge clk);
    ready = 1;
    // Step 1: Prepare input like C code: r[i] = i % KYBER_Q
    for (i = 0; i < 256; i = i + 1) begin
      i_data = (i % KYBER_Q); // fits in 16-bit signed
      @(posedge clk);
    end
    ready = 0;
    $display("Input finish: %d cycles", cycles);

    // give one clock to allow o_data to be stable if needed
    @(posedge clk);

    i = 0;
    while (i < 256) begin
      @(negedge clk);
      if (valid) begin
        if (i == 0) begin
          $display("Computation finish: %d cycles", cycles);
        end
        r_out[i] = o_data;
        i = i + 1;
      end
    end

    $display("Output finish: %d cycles", cycles);

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
