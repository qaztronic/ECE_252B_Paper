// --------------------------------------------------------------------
//
// --------------------------------------------------------------------

module tb_top;

  // --------------------------------------------------------------------
  localparam realtime PERIODS[1] = '{10ns};
  localparam CLOCK_COUNT = $size(PERIODS);
  
  // --------------------------------------------------------------------
  bit tb_clk[CLOCK_COUNT];
  wire tb_aresetn;
  bit tb_reset[CLOCK_COUNT];
  
  tb_base #(.N(CLOCK_COUNT), .PERIODS(PERIODS)) tb(.*);
  
  // --------------------------------------------------------------------
  wire clk_100mhz = tb_clk[0];
  wire reset = tb_reset[0];

  // --------------------------------------------------------------------
  logic [4:1] x;
  logic       c_in;
  wire s;
  wire c;
  wire c_out;
  
  counter_5_to_3 dut(.*);
  
  // --------------------------------------------------------------------
  string sum_pass;
  
  initial
  begin
    wait(~reset);
    repeat(4) @(posedge clk_100mhz);

    for(int i = 0; i < 2**5; i++)
    begin
      x = i[3:0];
      c_in = i[4];
      repeat(4) @(posedge clk_100mhz);
      sum_pass = (x[1] + x[2] + x[3] + x[4] + c_in == s + (2 * (c + c_out)) ) ? "PASS" : "FAIL";
      $display("x: %b | c_in: %b :: s: %b | c: %b  | c_out: %b || %s"
      , x, c_in, s, c, c_out, sum_pass);
    end

    $display("Test Done!!!");
    $stop;
  end

// --------------------------------------------------------------------
endmodule
