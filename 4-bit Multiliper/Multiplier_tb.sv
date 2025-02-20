module kgd(
	input wire [3:0] A,
	input wire [3:0] B,
	output reg [7:0] P
);

	always_comb begin
		P = 8'b0;
		for(int i = 0;i<4;i++) begin
			if(B[i] != 1'b0) begin
				P = P + (A << i);
			end
			else 
				P = P + 0;
		end
	end
	
endmodule

module tb;

	reg [3:0] A;
	reg [3:0] B;
	wire [7:0] P;
	wire [7:0] Pkgd;
	
	Multipilier DUT(.A(A),.B(B),.P(P));
	kgd DUT1(.A(A),.B(B),.P(Pkgd));
	
	class packet;
		randc bit [3:0] A;
		randc bit [3:0] B;
	endclass
	
	packet pkt;
	
	covergroup cc_group;
	
		cp1 : coverpoint A {bins b1 = {[0:15]};}
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
		
			repeat(5) begin
		
				pkt = new();
				pkt.randomize();
				
				A = pkt.A;
				B = pkt.B;
				
				// A = 5;
				// B = 5;
				
				#20;
				
				if(P === Pkgd)
					$display("Test Bench Passed A = %0d, B = %0d, P = %0d,Pkgd = %0d",A,B,P,Pkgd);
				else
					$display("Test Bench Failed A = %0d, B = %0d, P = %0d,Pkgd = %0d",A,B,P,Pkgd);
			end
			
			#200;
			$finish;
				
			
		end
		
endmodule