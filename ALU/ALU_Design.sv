import alu_package::*;

module alu_design(clock,reset,A,B,start_op,op_sel,result,end_op);

	input logic clock,reset;
	input logic [IN_WIDTH - 1 : 0] A;
	input logic [IN_WIDTH - 1 : 0] B;
	input logic start_op;
	input [OP_WIDTH - 1 : 0] op_sel;
	output logic [OUT_WIDTH - 1 : 0] result;
	output logic end_op;
	
	logic [OUT_WIDTH - 1 : 0] mul_done1,mul_done2;
	int counter;
	
	always_ff @(posedge clock or posedge reset)
	begin
		if(reset) begin
			result <= 0;
			end_op <= 0;
			counter <= 0;
			mul_done1 <= 0;
			mul_done2 <= 0;
		end
		else if(start_op) begin
			unique case(op_sel)
				3'b000	:	begin
								result <= 0;
								end_op <= 1;
							end
				3'b001		:	begin
								result <= A + B;
								end_op <= 1;
							end
				3'b010		:	begin
								result <= A - B;
								end_op <= 1;
							end
				3'b011		:	begin
								result <= A ^ B;
								end_op <= 1;
							end
				3'b100		:	begin
								mul_done1 <= A * B;
								mul_done2 <= mul_done1;
								result <= mul_done2;
								if(counter >= 2) begin
									counter <= 0;
									end_op <= 1;
								end
								else begin
									counter = counter + 1;
									end_op <= 0;
								end
							end
				3'b101		:	begin
								result <= A & B;
								end_op <= 1;
							end
				default	:	begin
								result <= 0;
								end_op <= 0;
							end
			endcase
		end
		else begin
			result <= 0;
			end_op <= 0;
			counter <= 0;
			mul_done1 <= 0;
			mul_done2 <= 0;
		end
		
	end
	
endmodule


interface alu_if;
	logic clock,reset;
	logic [IN_WIDTH - 1 : 0] A;
	logic [IN_WIDTH - 1 : 0] B;
	logic start_op;
	logic [OP_WIDTH - 1 : 0] op_sel;
	logic [OUT_WIDTH - 1 : 0] result;
	logic end_op; 
endinterface 
				
			