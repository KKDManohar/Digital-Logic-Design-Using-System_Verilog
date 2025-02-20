module KGD(
	input wire [3:0] A,
	input wire [3:0] B,
	input wire Cin,
	output reg [4:0] S
);

	wire [4:0] c;
	
	assign c[0] = Cin;
	
	genvar i;
	
	generate 
		
		for(i = 0;i<4;i++) begin
			
			Sub Dut(.A(A[i]),.B(B[i]),.Cin(c[i]),.Cout(c[i+1]),.S(S[i]));
			
		end
		
	endgenerate
	
	assign S[4] = c[4];
	
endmodule

module Sub(
		input wire A,
		input wire B,
		input wire Cin,
		output reg Cout,
		output reg S
	);
		always_comb begin
			
			S = A ^ B ^ Cin;
			
			Cout = (((~A) & Cin) | ((~A) & B) | (B & Cin));
		
		end
		
	endmodule


module top;

	reg [3:0] A;
	reg [3:0] B;
	reg Cin;
	wire [4:0] S;
	wire [4:0] SKgd;
	
	
	adderSub DUT(.A(A),.B(B),.Cin(Cin),.S(S));
	KGD DUT1(.A(A),.B(B),.Cin(0),.S(SKgd));
	
	class packet;
		randc bit [3:0] A;
		rand bit [3:0] B;
		randc bit Cin;
		
		constraint c1 {B > A;}
	endclass
	
	packet pkt;
	
	covergroup cc_group;
	
		cp1 : coverpoint A {bins b1[4] = {[0:15]};}
		cp2 : coverpoint B {bins b2[4] = {[0:15]};}
		cp3 : coverpoint Cin {bins b3[2] = {[0:1]};}
		
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
				Cin = pkt.Cin;
				
		
			// A = 4'h5;
			// B = 4'h3;
			
			// Cin = 1;
				
				#20;
				if(Cin) begin
					if(S === SKgd)
						$display("Test Bench Passed A = %0d, B = %0d, Cin = %0d, S = %0b and A - B = %0b",A,B,Cin,S,SKgd);
					else 
						$display("Test Bench Failed A = %0d, B = %0d, Cin = %0d, S = %0b and A - B = %0b",A,B,Cin,S,SKgd);
				end
				else begin
					if(S === A + B)
						$display("Test Bench Passed A = %0d, B = %0d, Cin = %0d, S = %0d and A + B = %0d",A,B,Cin,S,A+B);
					else 
						$display("Test Bench Failed A = %0d, B = %0d, Cin = %0d, S = %0d and A + B = %0d",A,B,Cin,S,A+B);
				end
			end
			
			#200;
			
			$finish;
				
		end

endmodule