module Mux2to1(
	input wire A0,
	input wire A1,
	input wire S0,
	output reg Y
);

	always_comb begin
	
		Y = S0 ? A1 : A0;
	
	end
	
endmodule

module Mux8to1(
	input wire [7:0] A,
	input wire [2:0] S,
	output reg Y
);

	   wire y0,y1,y2,y3,y00,y11;
	   
	   Mux2to1 DUT1(.A0(A[0]),.A1(A[1]),.S0(S[0]),.Y(y0));
	   Mux2to1 DUT2(.A0(A[2]),.A1(A[3]),.S0(S[0]),.Y(y1));
	   Mux2to1 DUT3(.A0(A[4]),.A1(A[5]),.S0(S[0]),.Y(y2));
	   Mux2to1 DUT4(.A0(A[6]),.A1(A[7]),.S0(S[0]),.Y(y3));
	   
	   Mux2to1 DUT5(.A0(y0),.A1(y1),.S0(S[1]),.Y(y00));
	   Mux2to1 DUT6(.A0(y2),.A1(y3),.S0(S[1]),.Y(y11));
	   
	   Mux2to1 DUT7(.A0(y00),.A1(y11),.S0(S[2]),.Y(Y));
	   
endmodule
	