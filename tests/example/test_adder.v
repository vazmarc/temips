//==================================
// Test Module
//==================================

`ifndef TEST_ADDER_V
`define TEST_ADDER_V

module test_adder (
  input	  [15:0]  in0, in1,
  input	          cin,
  output  [15:0]  out,
  output          cout
);

  assign {cout, out} = in0 + in1 + cin;

endmodule

`endif

