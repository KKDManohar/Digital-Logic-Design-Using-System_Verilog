`include "ALU_Environment.sv"

program test(ALU_intf vintf);
	Environment env;
	
	initial
	begin
	
		env = new(vintf);
		
		env.gen.tx_count = 20;
		
		env.run();
		
	end
	
endprogram
		
		
		
		