// --------------------------------------------------------------------
//
// --------------------------------------------------------------------

module bit_serial_multiplier #(N)
( input  clk
, input  x
, input  y
, input  first_bit
, input  last_bit
, output p
);
  // --------------------------------------------------------------------
  wire xy = x & y;
  wire c_in_0 = 0;
  wire [N-2:1] p_out;
  wire [N-2:0] c_out;
  wire [N-2:0] r_out;

  generate
    for(genvar j = 0; j < N - 1; j++)
      if(j == 0)
      begin : first
        bit_serial_multiplier_slice slice
        ( .p_in (p_out[j+1])
        , .c_in (c_in_0)
        , .r_in (first_bit)
        , .p_out(p)
        , .c_out(c_out[j])
        , .r_out(r_out[j])
        , .*
        );
      end
      else if(j < N - 2)
      begin : middle
        bit_serial_multiplier_slice slice
        ( .p_in (p_out[j+1])
        , .c_in (c_out[j-1])
        , .r_in (r_out[j-1])
        , .p_out(p_out[j])
        , .c_out(c_out[j])
        , .r_out(r_out[j])
        , .*
        );
      end
      else
      begin : last
        wire p_in_mux = r_out[j] ? xy : c_out[j];

        bit_serial_multiplier_slice slice
        ( .p_in (p_in_mux)
        , .c_in (c_out[j-1])
        , .r_in (r_out[j-1])
        , .p_out(p_out[j])
        , .c_out(c_out[j])
        , .r_out(r_out[j])
        , .*
        );
      end
  endgenerate

// --------------------------------------------------------------------
endmodule

