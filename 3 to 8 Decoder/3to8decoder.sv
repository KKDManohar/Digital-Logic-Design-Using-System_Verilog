module decoder2to1 (
	input wire A,
	input wire en,
	output reg Y0,
	output reg Y1
);


	always_comb begin
		
		if(en) begin
			Y0 = !A;
			Y1 = A;
		end
		else begin
			Y0 = 0;
			Y1 = 0;
		end
		
	end
	
endmodule

module decoder3to8(
	input wire [2:0] A,
	input wire en,
	output reg [7:0] Y
);

	wire y0,y1,y00,y01,y10,y11;
	
	decoder2to1 DUT1 (.A(A[2]),.en(en),.Y0(y0),.Y1(y1));
	
	decoder2to1 DUT2 (.A(A[1]),.en(y0),.Y0(y00),.Y1(y01));
	decoder2to1 DUT3 (.A(A[1]),.en(y1),.Y0(y10),.Y1(y11));
	
	decoder2to1 DUT4 (.A(A[0]),.en(y00),.Y0(Y[0]),.Y1(Y[1]));
	decoder2to1 DUT5 (.A(A[0]),.en(y01),.Y0(Y[2]),.Y1(Y[3]));
	decoder2to1 DUT6 (.A(A[0]),.en(y10),.Y0(Y[4]),.Y1(Y[5]));
	decoder2to1 DUT7 (.A(A[0]),.en(y11),.Y0(Y[6]),.Y1(Y[7]));
	
endmodule