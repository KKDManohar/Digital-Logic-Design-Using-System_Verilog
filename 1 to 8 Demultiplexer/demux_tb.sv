module top;

	reg Y;
	reg [2:0] S;
	wire [7:0] A;
	
	class packet;
	
		rand reg [2:0] S;
		
		// constraint s_var {
			// S inside {[2:0]};
		// }
		
	endclass
	
	packet pkt;
	
	demux1to8 DUT (.Y(Y),.S(S),.A(A));
	
	covergroup cc_group;
		cp1 : coverpoint S {bins b1[3] = {[0:7]};}
	endgroup
	
	cc_group cc;
	
	initial begin
		cc = new();
		forever #5 cc.sample();
	end
	
	initial begin
		
		Y = 1'b1;
		
		repeat (10) begin
		
			pkt = new();
			pkt.randomize();
			
			S = pkt.S;
			//S = $urandom_range(0,7);
		
			#20;
			
			if(A[S] == Y)
				$display("Test Bench Passed Y = %0b, S = %0b, A = %0b",Y,S,A);
			else
				$display("Test Bench Failed Y = %0b, S = %0b, A = %0b",Y,S,A);
			
		end
		
		#200;
		$finish;
		
	end
	
endmodule