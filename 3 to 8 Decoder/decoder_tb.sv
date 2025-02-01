module top;

	reg [2:0] A;
	reg en;
	wire [7:0] Y;
	
	class packet;
	
		rand bit [2:0] A;
		
	endclass
	
	decoder3to8 DUT (.A(A),.en(en),.Y(Y));
	
	covergroup cc_group;
	
		cp1 : coverpoint A {bins b1[3] = {[0:7]};}
		
	endgroup
	
	cc_group cc;
	
	initial
		begin
			cc = new();
			forever #5 cc.sample();
		end
	
	packet pkt;
	
	initial
		begin
		
			en = 1'b1;
			
			repeat (10) begin
				pkt = new();
				pkt.randomize();
				A = pkt.A;
				
				#20;
				
				if(Y[A] === 1)
					$display("Test Bench Passed en = %0b, A = %0d, Y = %0b",en,A,Y);
				else
					$display("Test Bench Passed en = %0b, A = %0d, Y = %0b",en,A,Y);
			end
				
			#200;
			$finish;
		
		end
		
endmodule