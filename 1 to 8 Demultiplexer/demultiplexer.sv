module demux1to2 (
	input wire Y,
	input wire S,
	output reg A0,
	output reg A1
);

	always_comb begin
		
		A0 = Y & !S;
		A1 = Y & S;
		
	end

endmodule

module demux1to8 (
	input wire Y,
	input wire [2:0] S,
	output reg [7:0] A
);

	wire y0,y1,y00,y01,y10,y11;

	demux1to2 DUT1(.Y(Y),.S(S[2]),.A0(y0),.A1(y1));
	
	demux1to2 DUT2(.Y(y0),.S(S[1]),.A0(y00),.A1(y01));
	demux1to2 DUT3(.Y(y1),.S(S[1]),.A0(y10),.A1(y11));
	
	demux1to2 DUT4(.Y(y00),.S(S[0]),.A0(A[0]),.A1(A[1]));
	demux1to2 DUT5(.Y(y01),.S(S[0]),.A0(A[2]),.A1(A[3]));
	demux1to2 DUT6(.Y(y10),.S(S[0]),.A0(A[4]),.A1(A[5]));
	demux1to2 DUT7(.Y(y11),.S(S[0]),.A0(A[6]),.A1(A[7]));
	
endmodule