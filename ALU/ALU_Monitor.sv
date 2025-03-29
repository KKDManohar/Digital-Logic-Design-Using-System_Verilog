class Monitor;

	Transaction trans;
	
	virtual ALU_intf vintf;
	
	mailbox mon2scb;
	
	function new(virtual ALU_intf vintf,mailbox mon2scb);
		this.vintf = vintf;
		this.mon2scb=mon2scb;
	endfunction
	
	task main();
		forever begin
			trans = new();
			
			@(posedge vintf.clock);
			//wait(vintf.start_op);
			trans.start_op <= vintf.start_op;
			//wait(trans.start_op);
			trans.A <= vintf.A;
			trans.B <= vintf.B;
			trans.op_sel <= vintf.op_sel;
			@(posedge vintf.clock);
			trans.result <= vintf.result;
			trans.end_op <= vintf.end_op;
			
			mon2scb.put(trans);
		end
	endtask
	
endclass