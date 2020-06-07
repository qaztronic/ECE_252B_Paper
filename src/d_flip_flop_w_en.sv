// --------------------------------------------------------------------
//
// --------------------------------------------------------------------

module d_flip_flop_w_en
( input  clk
, input  d
, input  en
, input  reset
, output reg q
, output q_n
);
  // --------------------------------------------------------------------
  assign q_n = ~q;

  always_ff @(posedge clk)
    if(reset)
      q <= 0;
    else if(en)
      q <= d;

// --------------------------------------------------------------------
endmodule