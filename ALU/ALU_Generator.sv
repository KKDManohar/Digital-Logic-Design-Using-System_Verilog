class Generator;

	Transaction tx;
	
	mailbox gen2drv;
	
	int tx_count;
	
	event ended;
	
	function new(mailbox gen2drv);
		this.gen2drv = gen2drv;
	endfunction
	
	task main();
		repeat(tx_count) 
		begin
			tx = new();
			if(!tx.randomize())
				$fatal("Transaction is not randomized");
			gen2drv.put(tx);
		end
		
		-> ended;
		
		//$display("generator ended");
	endtask
	
endclass