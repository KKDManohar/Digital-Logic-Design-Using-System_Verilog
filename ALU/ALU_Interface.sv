interface ALU_intf(input logic clock,reset);

	logic [IN_WIDTH - 1 : 0] A;
	logic [IN_WIDTH - 1 : 0] B;
	logic start_op;
	logic [OP_WIDTH - 1 : 0] op_sel;
	
	logic end_op;
	logic [OUT_WIDTH - 1 : 0] result;
	
endinterface
	