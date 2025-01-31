module top;

	reg [7:0] A;
	reg [2:0] S;
	wire Y;
	
	class packet;
	
		rand bit [7:0] A;
		rand bit [2:0] S;
		
	endclass
	
	
	packet P;
	
	Mux8to1 DUT (.A(A),.S(S),.Y(Y));
	
	covergroup c_group;
		cp1 : coverpoint A {bins b1[8] = {[0:255]};}
		cp2 : coverpoint S {bins b1[3] = {[0:7]};}
	endgroup
	
	c_group cc;
	
	initial
		begin
			cc = new();
			forever #1 cc.sample();
		end
	
	initial
		begin
		
			repeat(20) begin
				// A = $urandom_range(0,255);
				// S = $urandom_range(0,7);
				
				P = new();
				
				P.randomize();
				A = P.A;
				S = P.S;
				
				#1;
				
				if(Y == A[S])
					$display("Test Bench Passed A = %0b, S = %0d, Y = %0b",A,S,Y);
				else 
					$display("Test Bench Failed A = %0b, S = %0d, Y = %0b",A,S,Y);
			end
			
			#200;
			$finish;
				
		end
		
		
		
		
endmodule