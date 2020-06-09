// --------------------------------------------------------------------
//
// --------------------------------------------------------------------

module bit_serial_multiplier_slice
( input  clk
, input  x
, input  y
, input  xy
, input  p_in
, input  c_in
, input  r_in
, input  last_bit
, output p_out
, output c_out
, output r_out
);
  // --------------------------------------------------------------------
  wire reset = last_bit;
  wire en = r_in;
  
  // ------------------------------------------------------------------
  wire [4:1] c_x    ;
  wire       c_c_in ;
  wire       c_s    ;
  wire       c_c    ;
  wire       c_c_out;

  counter_5_to_3 counter_5_to_3_i
  ( .x    (c_x    )
  , .c_in (c_c_in )
  , .s    (c_s    )
  , .c    (c_c    )
  , .c_out(c_c_out)
  );

  // --------------------------------------------------------------------
  wire x_ff_q;

  d_flip_flop_w_en x_ff_i(.d(x), .q(x_ff_q), .q_n(), .*);

  // --------------------------------------------------------------------
  wire y_ff_q;

  d_flip_flop_w_en y_ff_i(.d(y), .q(y_ff_q), .q_n(), .*);

  // --------------------------------------------------------------------
  wire p_in_ff_q;

  d_flip_flop p_in_ff_i(.d(p_in), .q(p_in_ff_q), .q_n(), .*);

  // --------------------------------------------------------------------
  wire feedback_ff_q;

  d_flip_flop feedback_ff_i(.d(c_c), .q(feedback_ff_q), .q_n(), .*);

  // -------------------------------------------------------------------
  d_flip_flop c_out_ff_i(.d(c_c_out), .q(c_out), .q_n(), .*);

  // -------------------------------------------------------------------
  d_flip_flop r_out_ff_i(.d(r_in), .q(r_out), .q_n(), .*);

  // --------------------------------------------------------------------
  // mux m0(c_s, xy, r_in, p_out);
  assign p_out = r_in ? xy : c_s;
  
  // --------------------------------------------------------------------
  assign c_x[1] = x_ff_q & y;
  assign c_x[2] = y_ff_q & x;
  assign c_x[3] = p_in_ff_q;
  assign c_x[4] = c_in;
  assign c_c_in = feedback_ff_q;

// --------------------------------------------------------------------
endmodule
