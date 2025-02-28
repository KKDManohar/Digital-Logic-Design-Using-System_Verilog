module mul (
	input [3:0] a,b,
	output reg [7:0] y
);

	assign y = a * b;
	
endmodule


interface mul_intf;
	logic [3:0] a;
	logic [3:0] b;
	logic [7:0] y;
endinterface