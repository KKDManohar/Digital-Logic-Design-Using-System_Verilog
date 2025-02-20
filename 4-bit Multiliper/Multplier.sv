module Multipilier(
	input wire [3:0] A,
	input wire [3:0] B,
	output reg [7:0] P
);

	wire p01,p02,p03;
	wire p11,p12,p13,p14,c11,c12,c13,c14,s11,s12,s13;
	wire p21,p22,p23,p24,c21,c22,c23,c24,s21,s22,s23;
	wire p31,p32,p33,p34,c31,c32,c33,c34,s31,s32,s33;
	
	assign P[0] = A[0] & B[0];
	assign p01 = A[1] & B[0];
	assign p02 = A[2] & B[0];
	assign p03 = A[3] & B[0];
	
	assign p11 = A[0] & B[1];
	assign p12 = A[1] & B[1];
	assign p13 = A[2] & B[1];
	assign p14 = A[3] & B[1];
	
	assign p21 = A[0] & B[2];
	assign p22 = A[1] & B[2];
	assign p23 = A[2] & B[2];
	assign p24 = A[3] & B[2];
	
	assign p31 = A[0] & B[3];
	assign p32 = A[1] & B[3];
	assign p33 = A[2] & B[3];
	assign p34 = A[3] & B[3];
	
	
	HalfAdder HA1(.A(p01),.B(p11),.S(P[1]),.Cout(c11));
	FullAdder FA1(.A(p02),.B(p12),.Cin(c11),.S(s11),.Cout(c12));
	FullAdder FA2(.A(p03),.B(p13),.Cin(c12),.S(s12),.Cout(c13));
	HalfAdder HA2(.A(p14),.B(p14),.S(s13),.Cout(c14));
	
	HalfAdder HA3(.A(p21),.B(s11),.S(P[2]),.Cout(c21));
	FullAdder FA3(.A(p22),.B(s12),.Cin(c21),.S(s21),.Cout(c22));
	FullAdder FA4(.A(p23),.B(s13),.Cin(c22),.S(s22),.Cout(c23));
	FullAdder FA5(.A(p24),.B(c14),.Cin(c23),.S(s23),.Cout(c24));
	
	HalfAdder HA4(.A(p31),.B(s21),.S(P[3]),.Cout(c31));
	FullAdder FA6(.A(p32),.B(s22),.Cin(c31),.S(P[4]),.Cout(c32));
	FullAdder FA7(.A(p33),.B(s23),.Cin(c32),.S(P[5]),.Cout(c33));
	FullAdder FA8(.A(p34),.B(c24),.Cin(c33),.S(P[6]),.Cout(P[7]));
	
endmodule
	
	
	
	
	