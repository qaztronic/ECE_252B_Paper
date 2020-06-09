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
    // @(negedge clk);
    last_bit = 0;
    @(posedge clk);
    first_bit = 1;

    for(int i = 0; i < K - 1; i++)
    begin
      x = x_p[i];
      y = y_p[i];
      @(posedge clk);
      // @(negedge clk);
      first_bit = 0;
      -> tick;
      result[i] = p;
      // $display("result[%d] = %d", i, x);
    end

    repeat(2) @(posedge clk);
    // repeat(2) @(negedge clk);
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

    // do_multply(3, 3, result);
    // $display("result = %d", result);
    // @(posedge clk);

    // do_multply(5, 5, result);
    // $display("result = %d", result);
    // @(posedge clk);

    // do_multply(5, 7, result);
    // $display("result = %d", result);
    // @(posedge clk);

    for(int a = 0; a < 2**3; a++)
      for(int b = 0; b < 2**3; b++)
      begin
        do_multply(a, b, result);
        sum_pass = (result == a * b) ? "PASS" : "FAIL";
        if(sum_pass == "FAIL") test_pass = "FAIL";
        $display("a: %d | b: %d | result: %d || %s", a, b, result, sum_pass);
        @(posedge clk);
      end

    repeat(4) @(posedge clk);
    test_done(test_pass);
  end

// --------------------------------------------------------------------
endmodule
