// --------------------------------------------------------------------
//
// --------------------------------------------------------------------

module mux
( input  a
, input  b
, input  s
, output f
);
  wire sb;
  not(sb,s);
  cmos tg1(f,a,sb,s);
  cmos tg2(f,b,s,sb);
endmodule
