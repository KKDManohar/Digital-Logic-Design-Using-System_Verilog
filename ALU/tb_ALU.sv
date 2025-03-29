import alu_package::*;
`include "ALU_Interface.sv"
`include "ALU_Test.sv"

module top;
	
	//logic [IN_WIDTH - 1 : 0] A,B;
	logic clock = 0;
	logic reset;
	// logic start_op;
	// logic [OP_WIDTH - 1 : 0] op_sel;
	// logic [OUT_WIDTH - 1 : 0] result;
	// logic end_op;
	
	always #5 clock = ~clock;
	
	initial 
	begin
		reset = 1;
		#5 reset = 0;
	end
	
	ALU_intf vintf(clock,reset);
	
	test test1(vintf);
	
	alu_design DUT(.clock(vintf.clock),
				   .reset(vintf.reset),
				   .A(vintf.A),.B(vintf.B),
				   .start_op(vintf.start_op),
				   .op_sel(vintf.op_sel),
				   .result(vintf.result),
				   .end_op(vintf.end_op)
				  );
	
	
	
	// initial
		// $monitor("reset = %d,end_op = %h",result,end_op);
	
	// initial
	// begin
		// reset = 1;
		// #5 reset = 0;
		
		// // op_sel = ADD;
		// A = 16'h8;
		// B = 16'h8;
		// // start_op = 1;
		// // wait(end_op)
		// // #5 start_op = 0;
		
		// op_sel = MUL;
		// #5 start_op = 1;
		// repeat (3) @(posedge clock);
		// wait(end_op);
		// #5 start_op = 0;
		
		// #20 $finish;
	// end
endmodule