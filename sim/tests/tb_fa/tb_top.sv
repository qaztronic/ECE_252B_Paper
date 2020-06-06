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
  logic a;
  logic b;
  logic c_in;
  wire sum;
  wire c_out;

  full_adder dut(.*);
  
  // --------------------------------------------------------------------
  string sum_pass;
  string c_out_pass;
  
  initial
  begin
    wait(~reset);
    repeat(4) @(posedge clk_100mhz);

    for(int i = 0; i < 2**3; i++)
    begin
      a = i[0];
      b = i[1];
      c_in = i[2];
      repeat(4) @(posedge clk_100mhz);
      sum_pass = (sum == a ^ b ^ c_in) ? "PASS" : "FAIL";
      c_out_pass = ( c_out == (a & b) | (a & c_in) | (b & c_in) ) ? "PASS" : "FAIL";
      $display("a: %b | b: %b | c_in: %b | sum: %b | c_out: %b || %s : %s"
              , a, b, c_in, sum, c_out, sum_pass, c_out_pass);
    end

    $display("Test Done!!!");
    $stop;
  end

// --------------------------------------------------------------------
endmodule
