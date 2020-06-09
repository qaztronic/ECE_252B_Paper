// --------------------------------------------------------------------
//
// --------------------------------------------------------------------

module counter_5_to_3
( input [4:1] x
, input c_in
, output s
, output c
, output c_out
);
  // --------------------------------------------------------------------
  wire x_lo = x[1] ^ x[2];
  wire x_hi = x[3] ^ x[4];
  wire x_all = x_lo ^ x_hi;

  // --------------------------------------------------------------------
  wire m0_out = x_lo ? x[3] : x[1];
  // mux m0(x[1], x[3], x_lo, m0_out);

  // --------------------------------------------------------------------
  wire m1_out = x_all ? c_in : x[4];
  // mux m1(x[4], c_in, x_all, m1_out);

  // --------------------------------------------------------------------
  assign c_out = m0_out;
  assign s = x_all ^ c_in;
  assign c = m1_out;

// --------------------------------------------------------------------
endmodule
