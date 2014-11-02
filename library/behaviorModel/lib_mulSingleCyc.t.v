//==================================================
// Single Cycle Multiplier Behavior Module Unit Test
//==================================================

`include "lib_mulSingleCyc.v"

module lib_mulSingleCyc_driver
  (
   input 	 clk,
   input 	 reset,
   
   output [31:0] req_in0,
   output [31:0] req_in1, 
   output 	 req_val,
   input 	 req_rdy,

   // input [63:0]  rsp_out,
   // input 	 rsp_val,
   // output 	 rsp_rdy,
   
   output 	 done
   );

   reg [63:0] 	 req_in;
   reg 		 req_val_reg;
   
   reg [63:0] 	 seq[10:0];

   reg [15:0] 	 index;
   reg 		 done_reg;

   assign {req_in0, req_in1} = req_in;
   assign req_val = req_val_reg;
   
   assign done = (index === 16'd10);

   always @( posedge clk ) begin
      if ( reset ) begin
	 req_in      <= 64'hzzzzzzzz_zzzzzzzz;
	 req_val_reg <= 1'b0;
	 index       <= 16'd0;
	 done_reg    <= 1'b1;
	 seq[0] <= 64'h00000000_00000000;
	 seq[1] <= 64'h00000001_00000001;
	 seq[2] <= 64'hffffffff_00000001;
	 seq[3] <= 64'h00000001_ffffffff;
	 seq[4] <= 64'hffffffff_ffffffff;
	 seq[5] <= 64'h00000008_00000003;
	 seq[6] <= 64'hfffffff8_00000008;
	 seq[7] <= 64'hfffffff8_fffffff8;
	 seq[8] <= 64'h0deadbee_10000000;
	 seq[9] <= 64'hdeadbeef_10000000;
      end else begin
	 if ( !done ) begin
	    req_in <= seq[index];
	    req_val_reg <= 1'b1;
	    if (req_rdy && req_val) begin
	       // $display("Driving Seq #%0d", index);
	       index <= index + 1;
	    end
	 end else begin
	    req_in <= 64'hzzzz_zzzz_zzzz_zzzz;
	    req_val_reg <= 1'b0;
	 end
      end
   end
   
endmodule // lib_mulSingleCyc_driver

module tb_top;

   initial begin
      $dumpfile("lib_mulSingleCyc.vcd");
      $dumpvars;
   end
   
   reg         clk = 1'b0;
   reg 	       reset;

   wire [31:0]  req_in0;
   wire [31:0]  req_in1; 
   wire 	req_val;
   wire 	req_rdy;
   wire [63:0] 	rsp_out;
   wire 	rsp_val;
   reg 		rsp_rdy;

   wire 	driver_done;

   lib_mulSingleCyc_driver dut_driver
     (
      .clk(clk),
      .reset(reset),
      
      .req_in0(req_in0),
      .req_in1(req_in1), 
      .req_val(req_val),
      .req_rdy(req_rdy),

      .done(driver_done)
      );
   
   
   lib_mulSingleCyc dut
     (
      .clk(clk),
      .reset(reset),

      .req_in0(req_in0),
      .req_in1(req_in1), 
      .req_val(req_val),
      .req_rdy(req_rdy),

      .rsp_out(rsp_out),
      .rsp_val(rsp_val),
      .rsp_rdy(rsp_rdy)
      );

   
   always #5 clk = ~clk;

   always @( posedge clk) begin
      if (rsp_val && rsp_rdy) begin
	 $display("Output: %16h", rsp_out);
      end
      
   end

   always @(*)
     if (driver_done) begin
	#25;
	$display("");
	$finish;
     end
   
   
   initial begin
      rsp_rdy = 1'b1;
      reset = 1'b1;
      #20;
      reset = 1'b0;
      #10000;
      $finish;
   end // initial begin

endmodule // test
