module  encoder8to3 (
	input wire [7:0] Y,
	input wire en,
	output reg [2:0] A
);

	// or or1(A[0], Y[1], Y[3], Y[5], Y[7]);
	// or or2(A[1], Y[2], Y[3], Y[6], Y[7]);
	// or or3(A[2], Y[4], Y[5], Y[6], Y[7]);
	
	always_comb begin
    
    // if(en && Y != 0) begin
      // A[0] = Y[1] | Y[3] | Y[5] | Y[7];
      // A[1] = Y[2] | Y[2] | Y[6] | Y[7];
      // A[2] = Y[4] | Y[4] | Y[7] | Y[7];
    // end
    // else begin
      // A[0] = 1'bx;
      // A[1] = 1'bx;
      // A[2] = 1'bx;
    // end
  // end
  
		if(en && Y != 0) begin
			casex (Y) 
				8'b1xxxxxxx	: A = 3'b111;
				8'bx1xxxxxx	: A = 3'b110;
				8'bxx1xxxxx	: A = 3'b101;
				8'bxxx1xxxx	: A = 3'b100;
				8'bxxxx1xxx	: A = 3'b011;
				8'bxxxxx1xx	: A = 3'b010;
				8'bxxxxxx1x	: A = 3'b001;
				8'bxxxxxxx1	: A = 3'b000;
				default		: A = 3'bxxx;
			endcase
		end
		else
			A = 3'bxxx;
	end
	
	

endmodule
	