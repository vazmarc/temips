//========================================
// Single Cycle Multiplier Behavior Module
//========================================

`ifndef LIB_MULSINGLECYC_V
`define LIB_MULSINGLECYC_V

module lib_mulSingleCyc
  (
   input 	 clk,
   input 	 reset,
   
   input [31:0]  req_in0,
   input [31:0]  req_in1, 
   input 	 req_val,
   output 	 req_rdy,

   output [63:0] rsp_out,
   output 	 rsp_val,
   input 	 rsp_rdy
   );

   reg 		 ready_reg = 1'b1;
   reg           done_reg  = 1'b0;
   reg [63:0] 	 out_reg   = 64'hzzzz_zzzz_zzzz_zzzz;
   
   assign req_rdy = ready_reg;
   assign rsp_val = done_reg;
   assign rsp_out = out_reg;
   
   always @( posedge clk ) begin
      if ( reset ) begin
	 out_reg   <= 64'hzzzz_zzzz_zzzz_zzzz;
	 ready_reg <= 1'b1;
	 done_reg  <= 1'b0;
      end else begin
	 if ( req_rdy && req_val ) begin
	    out_reg   <= req_in0 * req_in1;
	    ready_reg <= 1'b0;
	    done_reg  <= 1'b1;
	 end
	 if ( rsp_rdy && rsp_val ) begin
	    out_reg <= 64'hzzzz_zzzz_zzzz_zzzz;
	    ready_reg <= 1'b1;
	    done_reg  <= 1'b0;
	 end
      end
   end
   
endmodule

`endif

