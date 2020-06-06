// --------------------------------------------------------------------
//
// --------------------------------------------------------------------

module tb_top;
  timeunit 1ns;
  timeprecision 100ps;

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
  wire clk = clk_100mhz;

  // --------------------------------------------------------------------
  logic reset = 1;
  logic  a;
  logic  b;
  wire x;

  bit_serial_adder dut(.*);

  // --------------------------------------------------------------------
  event tick;

  task automatic do_add(input int a_p, input int b_p, output int result);
    int a_w = $clog2(a_p);
    int b_w = $clog2(b_p);
    int w = a_w > b_w ? a_w : b_w;

    reset = 1;
    @(negedge clk);
    reset = 0;

    for(int i = 0; i < w + 2; i++)
    begin
      a = a_p[i];
      b = b_p[i];
      @(posedge clk);
      // #(1);
      @(negedge clk);
      -> tick;
      result[i] = x;
      // $display("result[%d] = %d", i, x);
    end

    @(posedge clk);
    reset = 1;

  endtask

  // --------------------------------------------------------------------
  string sum_pass;
  string test_pass = "PASS";
  int result;

  initial
  begin
    wait(~tb_reset[0]);
    repeat(4) @(posedge clk);

    // do_add(1, 1, result);
    // $display("result = %d", result);
    // @(posedge clk);

    for(int x = 0; x < 2**3; x++)
      for(int y = 0; y < 2**3; y++)
      begin
        do_add(x, y, result);
        sum_pass = (result == x + y) ? "PASS" : "FAIL";
        if(sum_pass == "FAIL") test_pass = "FAIL";
        $display("x: %d | y: %d | result: %d || %s", x, y, result, sum_pass);
        @(posedge clk);
      end

    for(int x = 0; x < 2**3; x++)
      for(int y = 0; y < 2**3; y++)
      begin
        do_add(x * -1, y, result);
        sum_pass = (result == (x * -1) + y) ? "PASS" : "FAIL";
        if(sum_pass == "FAIL") test_pass = "FAIL";
        $display("x: %d | y: %d | result: %d || %s", x * -1, y, result, sum_pass);
        @(posedge clk);
      end

    for(int x = 0; x < 2**3; x++)
      for(int y = 0; y < 2**3; y++)
      begin
        do_add(x, y * -1, result);
        sum_pass = (result == x + (y * -1)) ? "PASS" : "FAIL";
        if(sum_pass == "FAIL") test_pass = "FAIL";
        $display("x: %d | y: %d | result: %d || %s", x, y * -1, result, sum_pass);
        @(posedge clk);
      end

    repeat(4) @(posedge clk);
    $display("--------------------------------------------------------------------");
    $display("Test %s!!!", test_pass);
    $stop;
  end

// --------------------------------------------------------------------
endmodule
