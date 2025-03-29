import alu_package::*;

class Transaction;

	rand bit [IN_WIDTH - 1 : 0] A;
	rand bit [IN_WIDTH - 1 : 0] B;
	rand bit start_op;
	rand bit [OP_WIDTH - 1 : 0] op_sel;
	
	logic [OUT_WIDTH - 1 : 0] result;
	logic end_op;
	
	constraint c1 {
		op_sel inside {[0:NUM_OF_OP]};
	}
	
	constraint c2 {
		A inside {[1:15]};
		B inside {[1:15]};
	}
	
endclass




	
	