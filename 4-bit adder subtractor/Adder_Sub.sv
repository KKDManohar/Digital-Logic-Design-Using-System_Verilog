module adderSub(
	input wire [3:0] A,
	input wire [3:0] B,
	input wire Cin,
	output reg [4:0] S
);

	wire [4:0] c;
	
	wire [3:0] bin;
	
	assign c[0] = Cin;
	
	assign bin = B ^ {4{Cin}};
	
	genvar i;
	
	generate 
		for(i = 0; i < 4; i++) begin
			
			//bin[i] = B[i] ^ Cin;
			
			fullAdder DUT (.A(A[i]),.B(bin[i]),.Cin(c[i]),.Cout(c[i+1]),.S(S[i]));
			
		end
		
	endgenerate
	
	assign S[4] = Cin ? ~c[4] : c[4];
	
endmodule
			