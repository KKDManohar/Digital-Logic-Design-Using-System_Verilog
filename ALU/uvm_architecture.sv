`include "uvm_macros.svh"
import uvm_pkg::*;
import alu_package::*;

class transaction extends uvm_sequence_item;
`uvm_object_utils(transaction)

	function new(input string path = "transaction");
		super.new(path);
	endfunction
	
	rand bit [IN_WIDTH - 1 : 0] A;
	rand bit [IN_WIDTH - 1 : 0] B;
	rand bit start_op;
	rand bit [OP_WIDTH - 1 : 0] op_sel;
	bit [OUT_WIDTH - 1 : 0] result;
	bit end_op;
	
endclass


class single_cycle_gen extends uvm_sequence#(transaction);
`uvm_object_utils(single_cycle_gen)

	transaction tr;
	
	//int no_of_transactions;

	function new(input string path = "single_gen");
		super.new(path);
	endfunction
	
	virtual task body();
		repeat(15)
		begin
			tr = transaction::type_id::create("tr");
			start_item(tr);
			assert(tr.randomize() with {tr.op_sel != 3'b100;});
			tr.start_op = 1;
			`uvm_info("Test1",$sformatf("A = %0d, B = %0d, start_op = %0d, op_sel = %0d",tr.A,tr.B,tr.start_op,tr.op_sel),UVM_NONE);
			finish_item(tr);
		end
	endtask

endclass

class multi_cycle_gen extends uvm_sequence#(transaction);
`uvm_object_utils(multi_cycle_gen)

	transaction tr;
	//int no_of_transactions;

	function new(input string path = "multi_cycle_gen");
		super.new(path);
	endfunction
	
	virtual task body();
		repeat(15)
		begin
			tr = transaction::type_id::create("tr");
			start_item(tr);
			assert(tr.randomize() with {tr.op_sel == 3'b100;});
			tr.start_op = 1;
			`uvm_info("Test1",$sformatf("A = %0d, B = %0d, start_op = %0d, op_sel = %0d",tr.A,tr.B,tr.start_op,tr.op_sel),UVM_NONE)
			finish_item(tr);
		end
	endtask
	
endclass


class drv extends uvm_driver#(transaction);
`uvm_component_utils(drv)

	transaction tr;
	//int no_of_transactions;
	
	virtual alu_if a_if;

	function new(input string path = "drv",uvm_component parent = null);
		super.new(path,parent);
	endfunction
	
	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		
		if(!uvm_config_db#(virtual alu_if)::get(this,"","a_if",a_if))
			`uvm_error("DRV","Unable to access the interface")
	endfunction
	
	virtual task run_phase(uvm_phase phase);
		super.run_phase(phase);
		forever begin
			tr = transaction::type_id::create("tr");
			seq_item_port.get_next_item(tr);
			// if(tr.start_op == 1)
			// begin
				a_if.start_op <= tr.start_op;
				a_if.A <= tr.A;
				a_if.B <= tr.B;
				a_if.op_sel <= tr.op_sel;
			// end
			`uvm_info("DRV",$sformatf("A = %0d, B = %0d, start_op = %0d, op_sel = %0d",tr.A,tr.B,tr.start_op,tr.op_sel),UVM_NONE)
			seq_item_port.item_done();
			repeat(5) @(posedge a_if.clock);
		end
	endtask
	
endclass

class mon extends uvm_monitor;
`uvm_component_utils(mon)

	virtual alu_if a_if;
	
	transaction tr;
	uvm_analysis_port#(transaction) send; 

	function new(input string path = "mon",uvm_component parent = null);
		super.new(path,parent);
	endfunction
	
	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		
		if(!uvm_config_db#(virtual alu_if)::get(this,"","a_if",a_if))
			`uvm_error("MON","Unable to access the interface")
		
		send = new("send",this);
		
		tr = transaction::type_id::create("tr");
		
	endfunction
	
	virtual task run_phase(uvm_phase phase);
		super.run_phase(phase);
		
		forever begin
			repeat(5) @(posedge a_if.clock);
			tr.A = a_if.A;
			tr.B = a_if.B;
			tr.start_op = a_if.start_op;
			tr.op_sel = a_if.op_sel;
			tr.result = a_if.result;
			tr.end_op = a_if.end_op;
			`uvm_info("DRV",$sformatf("A = %0d, B = %0d, start_op = %0d, op_sel = %0d, result = %0d, end_op = %0d",tr.A,tr.B,tr.start_op,tr.op_sel,tr.result,tr.end_op),UVM_NONE)
			send.write(tr);
		end
	endtask
	
endclass


class scb extends uvm_scoreboard;
`uvm_component_utils(scb)

	//virtual alu_if a_if;
	
	uvm_analysis_imp#(transaction,scb) recv;

	function new(input string path = "scb", uvm_component parent);
		super.new(path,parent);
	endfunction
	
	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		
		recv = new("recv",this);
		
	endfunction
	
	virtual function void write(transaction tr);		
		case(tr.op_sel)
			3'b000	: if(tr.result === 0)
						`uvm_info("SCB",$sformatf("Test Bench passed A = %0d, B = %0d, start_op = %0d, op_sel = %0d, result = %0d, end_op = %0d",tr.A,tr.B,tr.start_op,tr.op_sel,tr.result,tr.end_op),UVM_NONE)
					  else
						`uvm_info("SCB",$sformatf("Test Bench Failed A = %0d, B = %0d, start_op = %0d, op_sel = %0d, result = %0d, end_op = %0d",tr.A,tr.B,tr.start_op,tr.op_sel,tr.result,tr.end_op),UVM_NONE)

			3'b001	: if(tr.result === tr.A + tr.B)
						`uvm_info("SCB",$sformatf("Test Bench passed A = %0d, B = %0d, start_op = %0d, op_sel = %0d, result = %0d, end_op = %0d",tr.A,tr.B,tr.start_op,tr.op_sel,tr.result,tr.end_op),UVM_NONE)
					  else 
						`uvm_info("SCB",$sformatf("Test Bench Failed A = %0d, B = %0d, start_op = %0d, op_sel = %0d, result = %0d, end_op = %0d",tr.A,tr.B,tr.start_op,tr.op_sel,tr.result,tr.end_op),UVM_NONE)

			3'b010	: if(tr.result === tr.A - tr.B)
						`uvm_info("SCB",$sformatf("Test Bench passed A = %0d, B = %0d, start_op = %0d, op_sel = %0d, result = %0d, end_op = %0d",tr.A,tr.B,tr.start_op,tr.op_sel,tr.result,tr.end_op),UVM_NONE)
					  else 
						`uvm_info("SCB",$sformatf("Test Bench Failed A = %0d, B = %0d, start_op = %0d, op_sel = %0d, result = %0d, end_op = %0d",tr.A,tr.B,tr.start_op,tr.op_sel,tr.result,tr.end_op),UVM_NONE)
			
			3'b011	: if(tr.result === tr.A ^ tr.B)
						`uvm_info("SCB",$sformatf("Test Bench passed A = %0d, B = %0d, start_op = %0d, op_sel = %0d, result = %0d, end_op = %0d",tr.A,tr.B,tr.start_op,tr.op_sel,tr.result,tr.end_op),UVM_NONE)
					  else 
						`uvm_info("SCB",$sformatf("Test Bench Failed A = %0d, B = %0d, start_op = %0d, op_sel = %0d, result = %0d, end_op = %0d",tr.A,tr.B,tr.start_op,tr.op_sel,tr.result,tr.end_op),UVM_NONE)
			
			3'b100	: if(tr.result === tr.A * tr.B)
						`uvm_info("SCB",$sformatf("Test Bench passed A = %0d, B = %0d, start_op = %0d, op_sel = %0d, result = %0d, end_op = %0d",tr.A,tr.B,tr.start_op,tr.op_sel,tr.result,tr.end_op),UVM_NONE)
					  else 
						`uvm_info("SCB",$sformatf("Test Bench Failed A = %0d, B = %0d, start_op = %0d, op_sel = %0d, result = %0d, end_op = %0d",tr.A,tr.B,tr.start_op,tr.op_sel,tr.result,tr.end_op),UVM_NONE)
			
			3'b101	: if(tr.result === tr.A & tr.B)
						`uvm_info("SCB",$sformatf("Test Bench passed A = %0d, B = %0d, start_op = %0d, op_sel = %0d, result = %0d, end_op = %0d",tr.A,tr.B,tr.start_op,tr.op_sel,tr.result,tr.end_op),UVM_NONE)
					  else 
						`uvm_info("SCB",$sformatf("Test Bench Failed A = %0d, B = %0d, start_op = %0d, op_sel = %0d, result = %0d, end_op = %0d",tr.A,tr.B,tr.start_op,tr.op_sel,tr.result,tr.end_op),UVM_NONE)
		endcase
		
		$display("--------------------------------------------------------");
		
	endfunction
	
endclass


class agent extends uvm_agent;
`uvm_component_utils(agent);

	mon m;
	drv d;
	uvm_sequencer#(transaction) seqr;

	function new(input string path = "agent",uvm_component parent);
		super.new(path,parent);
	endfunction;
	
	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		
		m = mon::type_id::create("m",this);
		d = drv::type_id::create("d",this);
		seqr = uvm_sequencer#(transaction)::type_id::create("seqr",this);
		
	endfunction
	
	virtual function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		
		d.seq_item_port.connect(seqr.seq_item_export);
		
	endfunction
	
endclass

class env extends uvm_env;
`uvm_component_utils(env);

	agent a;
	scb s;
	
	function new(input string path = "env", uvm_component parent);
		super.new(path,parent);
	endfunction
	
	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		
		a = agent::type_id::create("a",this);
		s = scb::type_id::create("s",this);
		
	endfunction
	
	virtual function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		
		a.m.send.connect(s.recv);
		
	endfunction
	
endclass

class test extends uvm_test;
`uvm_component_utils(test)

	env e;
	single_cycle_gen sc;
	multi_cycle_gen mc;
	
	function new(input string path = "env",uvm_component parent);
		super.new(path,parent);
	endfunction
	
	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		
		e = env::type_id::create("e",this);
		sc = single_cycle_gen::type_id::create("sc");
		mc = multi_cycle_gen::type_id::create("mc");
		
	endfunction
	
	virtual task run_phase(uvm_phase phase);
		// sc.no_of_transactions = 15;
		// mc.no_of_transactions = 15;
		//super.run_phase(phase);
		phase.raise_objection(this);
		sc.start(e.a.seqr);
		#40;
		mc.start(e.a.seqr);
		#40;
		phase.drop_objection(this);
	endtask

endclass

module tb;

	alu_if a_if();
	
	alu_design DUT(.clock(a_if.clock),.reset(a_if.reset),.A(a_if.A),.B(a_if.B),.start_op(a_if.start_op),.op_sel(a_if.op_sel),.result(a_if.result),.end_op(a_if.end_op));
	
	initial
		begin
			
			uvm_config_db#(virtual alu_if)::set(null,"*","a_if",a_if);
			
			run_test("test");
			
		end
		
	initial
		a_if.clock = 0;
		
	always #10 a_if.clock = ~a_if.clock;
	
	initial
		begin
			
			a_if.reset = 1;
			#20;
			a_if.reset = 0;
			
		end
		
endmodule

		
		
		
	
		
		
		
	
	
	
	
			
		
		
	
	