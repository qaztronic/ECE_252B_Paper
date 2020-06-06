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
  logic a = 0;
  logic b = 0;
  logic s = 0;
  wire  f;

  mux dut(.*);

  // --------------------------------------------------------------------
  logic result;
  string pass;
  
  initial
  begin
    wait(~reset);
    repeat(4) @(posedge clk_100mhz);

    for(int i = 0; i < 2**3; i++)
    begin
      a = i[0];
      b = i[1];
      s = i[2];
      repeat(4) @(posedge clk_100mhz);
      result = s ? b : a;
      pass = (f == result) ? "PASS" : "FAIL";
      $display("a: %b | b: %b | s: %b | f: %b || result: %b || %s", a, b, s, f, result, pass);
    end

    $display("Test Done!!!");
    $stop;
  end

// --------------------------------------------------------------------
endmodule
