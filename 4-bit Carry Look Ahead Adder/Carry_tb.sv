module tb;

	reg [3:0] A;
	reg [3:0] B;
	wire [4:0] S;
	
	top DUTtop(.A(A),.B(B),.S(S));
	
	class packet;
	
		randc bit [3:0] A;
		randc bit [3:0] B;
		
	endclass
	
	packet pkt;
	
	covergroup cc_group;
		cp1	: coverpoint A {bins b1[4] = {[0:15]};}
		cp2	: coverpoint B {bins b2[5] = {[0:15]};}
	endgroup
	
	cc_group cc;
	
	initial
		begin
			cc = new();
			forever #5 cc.sample();
		end
		
	
	initial
		begin
		
			
			repeat(5) begin

				pkt = new();
				
				pkt.randomize();
				
				A = pkt.A;
				B = pkt.B;
			
			// A = 4'b0001;
			// B = 4'b0001;
				
				#5;
				
				if(S === A+B)
					$display("Test Bench Passed : A = %0d, B = %0d, S = %0d",A,B,S);
				else
					$display("Test Bench Failed : A = %0d, B = %0d, S = %0d",A,B,S);

			
			end
			
			#200;
			$finish;
			
		end
		
endmodule