class Driver;

	mailbox gen2drv;
	
	virtual ALU_intf vintf;
	
	int drv_transaction_count;
	
	function new(virtual ALU_intf vintf,mailbox gen2drv);
		this.vintf = vintf;
		this.gen2drv = gen2drv;
	endfunction
	
	task reset();
		wait(vintf.reset)
		$display("Driver Reset Started");
		vintf.A <= 0;
		vintf.B <= 0;
		vintf.start_op <= 0;
		vintf.op_sel <= 0;
		wait(!vintf.reset)
		$display("Driver Reset ended");
	endtask
	
	task main();
		$display("Driver Main Started");
		forever begin
			Transaction trans;
			gen2drv.get(trans);
			@(posedge vintf.clock);
			//vintf.start_op <= trans.start_op;
			if(trans.start_op) begin
				vintf.start_op <= trans.start_op;
				vintf.A <= trans.A;
				vintf.B <= trans.B;
				vintf.op_sel <= trans.op_sel;
			end
			$display("A = %h, B = %h , op_sel = %d , start_op = %b, result = %d,end_op = %d",trans.A,trans.B,trans.op_sel,trans.start_op,vintf.result,vintf.end_op);
			// @(posedge vintf.clock);
			// trans.start_op <= 0;
			@(posedge vintf.clock);
			trans.result <= vintf.result;
			trans.end_op <= vintf.end_op;
			
			drv_transaction_count++;
		end
		$display("Driver Main Ended");
	endtask
endclass

