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
  localparam W = 3;
  localparam N = 2;
  
  logic reset;
  logic first_digit;
  logic [W-1:0] a;
  logic [W-1:0] b;
  wire  [W-1:0] s;

  digit_serial_adder #(W) dut(.*);


  // --------------------------------------------------------------------
  event tick;

  task automatic do_add(input int a_p, input int b_p, output int result);
    reset = 0;
    @(posedge clk);
    first_digit = 1;

    for(int i = 0; i < N; i++)
    begin
      @(negedge clk);
      a = a_p[i*W+:W];
      b = b_p[i*W+:W];
      @(posedge clk);
      -> tick;
      result[i*W+:W] = s;
      first_digit = 0;
    end

    // for(int i = N; i < K; i++)
    // begin
      // x = a_p[N - 1];
      // y = b_p[N - 1];
      // @(negedge clk);
      // -> tick;
      // result[i] = p;
      // @(posedge clk);
    // end

    repeat(2) @(posedge clk);
    reset = 1;

  endtask

  // --------------------------------------------------------------------
  string sum_pass;
  string test_pass = "PASS";
  int result;

  initial
  begin
    reset = 1;
    first_digit = 0;
  
    wait(~tb_reset[0]);
    reset = 0;
    repeat(4) @(posedge clk);
    reset = 1;

    do_add(1, 2, result);
    $display("result = %d", result);
    @(posedge clk);

    do_add(2, 2, result);
    $display("result = %d", result);
    @(posedge clk);

    do_add(3, 1, result);
    $display("result = %d", result);
    @(posedge clk);

    // for(int a = 0; a < 2**(N-1); a++)
      // for(int b = 0; b < 2**(N-1); b++)
      // begin
        // do_multply(a, b, result);
        // sum_pass = (result == a * b) ? "PASS" : "FAIL!!!";
        // if(sum_pass == "FAIL") test_pass = "FAIL";
        // $display("a: %d | b: %d | result: %d || %s", a, b, result, sum_pass);
        // @(posedge clk);
      // end

    repeat(4) @(posedge clk);
    test_done(test_pass);
  end

// --------------------------------------------------------------------
endmodule
