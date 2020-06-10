// --------------------------------------------------------------------
//
// --------------------------------------------------------------------

module digit_serial_adder #(W)
( input  clk
, input  reset
, input  first_digit
, input  [W-1:0] a
, input  [W-1:0] b
, output [W-1:0] s
);
  // --------------------------------------------------------------------
  wire carry_out_last_r;
  wire [W-1:0] c_out;

  generate
    for(genvar j = 0; j < W; j++)
      if(j == 0)
      begin : first
        wire c_in = carry_out_last_r & ~first_digit;

        full_adder fa_i
        ( .a    (a[j])
        , .b    (b[j])
        , .c_in (c_in)
        , .sum  (s[j+1])
        , .c_out(c_out[j])
        );
      end
      else if(j < W - 1)
      begin : middle
        full_adder fa_i
        ( .a    (a[j])
        , .b    (b[j])
        , .c_in (c_out[j-1])
        , .sum  (s[j+1])
        , .c_out(c_out[j])
        );
      end
      else
      begin : last
        wire sum;
        d_flip_flop sum_dff_i(.d(sum), .q(s[0]), .q_n(), .*);
        d_flip_flop c_out_dff_i(.d(c_out[j]), .q(carry_out_last_r), .q_n(), .*);

        full_adder fa_i
        ( .a    (a[j])
        , .b    (b[j])
        , .c_in (c_out[j-1])
        , .sum  (sum)
        , .c_out(c_out[j])
        );
      end
  endgenerate

// --------------------------------------------------------------------
endmodule

