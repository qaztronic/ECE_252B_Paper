// --------------------------------------------------------------------
//
// --------------------------------------------------------------------

module full_adder
( input  a
, input  b
, input  c_in
, output sum
, output c_out
);
  // --------------------------------------------------------------------
  wire m0_out;
  mux m0(b, c_in, a, m0_out);

  // --------------------------------------------------------------------
  wire m1_out;
  mux m1(c_in, b, a, m1_out);

  // --------------------------------------------------------------------
  wire m2_out;
  mux m2(m1_out, m0_out, c_in, m2_out);

  // --------------------------------------------------------------------
  wire m3_out;
  mux m3(a, m0_out, b, m3_out);

  // --------------------------------------------------------------------
  wire m4_out;
  mux m4(m1_out, a, b, m4_out);

  // --------------------------------------------------------------------
  wire m5_out;
  mux m5(m3_out, m4_out, c_in, m5_out);

  // --------------------------------------------------------------------
  assign sum   = m5_out;
  assign c_out = m2_out;

// --------------------------------------------------------------------
endmodule
