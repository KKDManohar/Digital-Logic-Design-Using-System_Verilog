module top;

	reg [3:0] A;
	reg [3:0] B;
	wire [4:0] S;
	
	RCA4bit DUT (.A(A),.B(B),.S(S));
	
	class packet;
		randc bit [3:0] A;
		randc bit [3:0] B;
		
		//rand bit [16:0] seen_values_A;
		
		// constraint cp1 { unique(A) == 1; }
		// constraint cp2 { unique(B) == 1; }
		
		// constraint unique_s {
			// seen_values_A[A] == 0;
		// }
		
		// constraint seen_reset {
			// if(seen_values_A == 16'b1111111111111111)
				// seen_values_A == 0;
		// }
		
		// constraint update_seen {
			// seen_values_A[A] == 1;
		// }
		
	endclass
	
	packet pkt;
	
	// covergroup cc_group;
		// cp1 : coverpoint A { unique (A); }
		// cp2 : coverpoint B { unique (B); }
		
	covergroup cc_group;
		cp1 : coverpoint A {bins b1[4] = {[0:15]};}
		cp2 : coverpoint B {bins b2[4] = {[0:15]};}
	endgroup
	
	cc_group cc;
	
	initial
		begin 
			cc = new();
			forever #5 cc.sample();
		end
		
	
	initial
		begin
		
			repeat(10) begin
				pkt = new();
				pkt.randomize();
				
				A = pkt.A;
				B = pkt.B;
				// A = $urandom_range(0,15);
				
				// B = $urandom_range(0,15);
				
				#20;
				
				if(S === (A+B))
					$display("Teste Bench Passed A = %0b, B = %0b, S = %0b",A,B,S);
				else
				$display("Teste Bench Passed A = %0b, B = %0b, S = %0b",A,B,S);
			end
			
			#200;
			$finish;
		end
		
endmodule