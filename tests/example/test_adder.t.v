//==================================
// Test bench
//==================================

`include "test_adder.v"

module test;
   reg  [15:0] in0, in1;
   reg         cin;
   wire [15:0] out;
   wire        cout;

   test_adder dut
     (
      .in0  (in0),
      .in1  (in1),
      .cin  (cin),
      .out  (out),
      .cout (cout)
      );

   initial begin
      in0 = 1;
      in1 = 1;
      cin = 1;
      
      $display("Out = %x, Count = %x",
	       out, cout);
      #1;
      $display("Out = %x, Count = %x",
	       out, cout);
      #5;
      $display("Out = %x, Count = %x",
	       out, cout);
      
   end // initial begin
   
endmodule // test
