`include "uvm_macros.svh"
import uvm_pkg::*;
`include "uvm_architecture.sv"

module tb;
	
	mul_intf mif();
	
	mul dut(.a(mif.a),.b(mif.b),.y(mif.y));
	
	initial
		begin
			uvm_config_db #(virtual mul_intf)::set(null,"*","mif",mif);
			run_test("test");
		end
		
	initial
		begin
			$dumpfile("dump.vcd");
			$dumpvars;
		end
		
endmodule
	
	