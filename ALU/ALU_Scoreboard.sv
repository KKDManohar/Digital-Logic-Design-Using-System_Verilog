class Scoreboard;
	
	mailbox mon2scb;
	
	int scb_tx_count;
	
	logic true;
	
	function new(mailbox mon2scb);
		this.mon2scb = mon2scb;
	endfunction
	
	task main();
		Transaction trans;
		forever begin
			mon2scb.get(trans);
			if(trans.start_op)
			begin
				case(trans.op_sel)
					3'b000	:	begin
									trans.result = 0;
									true = 1;
								end
					3'b001	:	begin
									trans.result = trans.A + trans.B;
									true = 1;
								end
					3'b010	:	begin
									trans.result = trans.A - trans.B;
									true = 1;
								end
					3'b011	:	begin
									trans.result = trans.A ^ trans.B;
									true = 1;
								end
					3'b100	:	begin
									trans.result = trans.A * trans.B;
									true = 1;
								end
					3'b101	:	begin
									trans.result = trans.A & trans.B;
									true = 1;
								end
				endcase
					if(true == 1) 
						$display("Scoreboard Passed");
					else
						$display("Scoreboard Failed");
			end
			scb_tx_count++;
		end
		
	endtask
	
endclass
							