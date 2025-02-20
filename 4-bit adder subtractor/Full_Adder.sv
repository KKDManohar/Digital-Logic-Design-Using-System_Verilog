module fullAdder(
	input wire A,
	input wire B,
	input wire Cin,
	output reg Cout,
	output reg S
);

	always_comb begin
	
		S = A ^ B ^ Cin;
		
		Cout = A & B | B & Cin | Cin & A;
		
	end
	
endmodule 