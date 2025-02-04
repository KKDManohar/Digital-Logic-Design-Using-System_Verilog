module halfAdder (
	input wire A,
	input wire B,
	output reg S,
	output reg Cout
);

	always_comb begin
		
		S = A ^ B;
		Cout = A & B;
	
	end
	
endmodule

module fullAdder (
	input wire A,
	input wire B,
	input wire Cin,
	output reg S,
	output reg Cout
);

	wire s0,c0,c1;

	halfAdder DUT1 (.A(A),.B(B),.S(s0),.Cout(c0));
	halfAdder DUT2 (.A(s0),.B(Cin),.S(S),.Cout(c1));
	
	assign Cout = c0 | c1;
	
endmodule

module RCA4bit (
	input wire [3:0] A,
	input wire [3:0] B,
	output reg [4:0] S
);

	wire [4:0] C;
	
	assign C[0] = 1'b0;
	
	genvar i;
	generate
		for (i = 0; i < 4; i++) begin
			fullAdder FA (.A(A[i]),.B(B[i]),.Cin(C[i]),.S(S[i]),.Cout(C[i+1]));
		end
	endgenerate
	
	assign S[4] = C[4];
	
endmodule