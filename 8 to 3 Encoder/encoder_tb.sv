module KGD(
	input wire [7:0] Y,
	input wire en,
	output reg [2:0] A
);

	always @(*) begin
		if(en) begin
			if (Y != 0) begin
				A = 3'b000;
				for(int i = 7; i >= 0; i--) begin
					if(Y[i] == 1) begin
						A = i;
					// else
						// A = 0;
						break;
					end
				end
			end
			else
				A = 3'bxxx;
		end
		else
			A = 3'bxxx;
	end
	
endmodule


module top;

	reg [7:0] Y;
	reg en;
	wire [2:0] A;
	
	wire [2:0] kgd_A; 
	
	class packet;
		randc bit [7:0] Y;
		
		constraint c1 {
			$countones(Y) == 1;
		}
		
	endclass
	
	packet pkt;
	
	encoder8to3 DUT (.Y(Y),.en(en),.A(A));
	KGD DUT1 (.Y(Y),.en(en),.A(kgd_A));
	
	covergroup cc_group;
		cp1	: coverpoint Y {bins b1[8] = {[0:255]};}
	endgroup
	
	cc_group cc; 
	
	initial
		begin
			cc = new();
			forever #5 cc.sample();
		end
	
	initial
		begin
		
			en = 1'b1;
			
			repeat(20) begin
			
				pkt = new();
				pkt.randomize();
				//Y = $urandom_range(0,7);
				//Y = 8'b00000001;
				Y = pkt.Y;
				
				#20;
				
				if(A === kgd_A) 
					$display("Test Bench Passed Y = %0b, expected kgd_A = %0b, A = %0b",Y,kgd_A,A);
				else
					$display("Test Bench Failed Y = %0b, expected kgd_A = %0b, A = %0b",Y,kgd_A,A);
			end
			
			#200;
			$finish;
			
		end
		
endmodule