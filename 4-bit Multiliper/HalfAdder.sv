module HalfAdder(
	input wire A,
	input wire B,
	output reg S,
	output reg Cout
);

	assign S = A ^ B;
	assign Cout = A & B;
	
endmodule