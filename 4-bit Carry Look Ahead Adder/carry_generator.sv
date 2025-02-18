module carry_generator(	
	input wire [3:0] P,
	input wire [3:0] G,
	input wire [4:0] Cin,
	output reg [4:1] Cout
);

	always_comb begin
	
		int i;
		
		//generate
		
			for(i = 0; i < 4; i++) begin
				Cout[i+1] = G[i] | (P[i] & Cin[i]);
			end
			
		//endgenerate
		
	end
	
endmodule

	