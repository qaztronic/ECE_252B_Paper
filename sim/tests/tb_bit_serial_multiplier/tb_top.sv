// --------------------------------------------------------------------
//
// --------------------------------------------------------------------

module tb_top;
  timeunit 1ns;
  timeprecision 100ps;
  import tb_top_pkg::*;

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
  localparam N = 3;
  localparam K = (2 * N) + 1;
  logic x        ;
  logic y        ;
  logic first_bit = 0;
  logic last_bit  = 1;
  wire p         ;

  bit_serial_multiplier #(K) dut(.*);

  // --------------------------------------------------------------------
  event tick;

  task automatic do_multply(input int x_p, input int y_p, output int result);
    // int a_w = $clog2(x_p);
    // int b_w = $clog2(y_p);
    // int w = a_w > b_w ? a_w : b_w;

    // last_bit = 1;
    // @(negedge clk);
    @(posedge clk);
    first_bit = 1;
    last_bit = 0;

    // for(int i = 0; i < w + 2; i++)
    for(int i = 0; i < K - 1; i++)
    begin
      x = x_p[i];
      y = y_p[i];
      @(posedge clk);
      // #(1);
      // @(negedge clk);
      first_bit = 0;
      -> tick;
      result[i] = p;
      // $display("result[%d] = %d", i, x);
    end

    // repeat(K) @(posedge clk);
    repeat(2) @(posedge clk);
    last_bit = 1;

  endtask

  // --------------------------------------------------------------------
  string sum_pass;
  string test_pass = "PASS";
  int result;

  initial
  begin
    wait(~tb_reset[0]);
    repeat(4) @(posedge clk);

    do_multply(3, 3, result);
    $display("result = %d", result);
    @(posedge clk);

    do_multply(5, 5, result);
    $display("result = %d", result);
    @(posedge clk);

    do_multply(5, 7, result);
    $display("result = %d", result);
    @(posedge clk);

    // for(int a = 0; a < 2**3; a++)
      // for(int b = 0; b < 2**3; b++)
      // begin
        // do_multply(a, b, result);
        // sum_pass = (result == a * b) ? "PASS" : "FAIL";
        // if(sum_pass == "FAIL") test_pass = "FAIL";
        // $display("a: %d | b: %d | result: %d || %s", a, b, result, sum_pass);
        // @(posedge clk);
      // end

    // for(int x = 0; x < 2**3; x++)
      // for(int y = 0; y < 2**3; y++)
      // begin
        // do_add(x * -1, y, result);
        // sum_pass = (result == (x * -1) + y) ? "PASS" : "FAIL";
        // if(sum_pass == "FAIL") test_pass = "FAIL";
        // $display("x: %d | y: %d | result: %d || %s", x * -1, y, result, sum_pass);
        // @(posedge clk);
      // end

    // for(int x = 0; x < 2**3; x++)
      // for(int y = 0; y < 2**3; y++)
      // begin
        // do_add(x, y * -1, result);
        // sum_pass = (result == x + (y * -1)) ? "PASS" : "FAIL";
        // if(sum_pass == "FAIL") test_pass = "FAIL";
        // $display("x: %d | y: %d | result: %d || %s", x, y * -1, result, sum_pass);
        // @(posedge clk);
      // end

    // repeat(4) @(posedge clk);
    // $display("--------------------------------------------------------------------");
    // $display("Test %s!!!", test_pass);
    // $stop;
    
    repeat(4) @(posedge clk);
    test_done(test_pass);
  end

// --------------------------------------------------------------------
endmodule
