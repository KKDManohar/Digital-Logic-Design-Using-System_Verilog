package alu_package;

	parameter IN_WIDTH = 16;
	parameter OUT_WIDTH = 32;
	parameter OP_WIDTH = 3;
	parameter NUM_OF_OP = 5;
	
	typedef enum logic[OP_WIDTH - 1 : 0] {
		NO_OP = 3'b000,
		ADD = 3'b001,
		SUB = 3'b010,
		XOR = 3'b011,
		MUL = 3'b100,
		AND = 3'b101
	} ALU_OP;
	
endpackage