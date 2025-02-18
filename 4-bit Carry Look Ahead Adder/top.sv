module top(
	input wire [3:0] A,
	input wire [3:0] B,
	output reg [4:0] S
);

	wire [4:0] Cin;
	wire [4:1] Cout;
	wire [3:0] P,G;

	fullAdder DUTFA(.A(A),.B(B),.Cin(Cin),.S(S[3:0]),.P(P),.G(G));
	
	carry_generator DUTCG(.P(P),.G(G),.Cin(Cin),.Cout(Cout));
	
	assign Cin[0] = 0;
	assign Cin[1] = Cout[1];
	assign Cin[2] = Cout[2];
	assign Cin[3] = Cout[3];
	assign Cin[4] = Cout[4];
	assign S[4] = Cout[4];
	
endmodule
	