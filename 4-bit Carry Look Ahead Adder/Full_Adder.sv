module fullAdder(
	input wire [3:0] A,
	input wire [3:0] B,
	input wire [4:0] Cin,
	output reg [3:0] S,
	output reg [3:0] G,
	output reg [3:0] P
);

	always_comb begin
		
		int i;
		
		//generate 
			for(i = 0;i < 4; i++) begin
				S[i] = A[i] ^ B[i] ^ Cin[i];
				P[i] = A[i] ^ B[i];
				G[i] = A[i] & B[i];
			end
		//endgenerate
		
		//s[4] = Cin[4] 
		
	end
	
endmodule 
				