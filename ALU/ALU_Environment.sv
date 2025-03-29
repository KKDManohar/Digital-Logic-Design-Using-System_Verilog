`include "ALU_Transaction.sv"
`include "ALU_Generator.sv"
`include "ALU_Driver.sv"
`include "ALU_Monitor.sv"
`include "ALU_Scoreboard.sv"


class Environment;

	Generator gen;
	Driver drv;
	Monitor mon;
	Scoreboard scb;
	
	mailbox gen2drv;
	mailbox mon2scb;
	 
	virtual ALU_intf vintf;
	
	function new(virtual ALU_intf vintf);
	
		this.vintf = vintf;
		
		gen2drv = new();
		mon2scb = new();
		
		gen = new(gen2drv);
		drv = new(vintf,gen2drv);
		mon = new(vintf,mon2scb);
		scb = new(mon2scb);
		
	endfunction
	
	task pre_test();
		drv.reset();
	endtask
	
	task test();
		fork
			gen.main();
			drv.main();
			mon.main();
			scb.main();
		join_any
	endtask
	
	task post_test();
		wait(gen.ended.triggered);
		wait(gen.tx_count == drv.drv_transaction_count);
		wait(gen.tx_count == scb.scb_tx_count);
	endtask
	
	task run();
		pre_test();
		test();
		post_test();
		$finish;
	endtask
	
endclass
	
	
	