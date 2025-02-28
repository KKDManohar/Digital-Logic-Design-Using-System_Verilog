`include "uvm_macros.svh"
import uvm_pkg::*;

class transcation extends uvm_sequence_item;
`uvm_object_utils(transcation)

	rand bit [3:0] a;
	rand bit [3:0] b;
	bit [7:0] y;
	
	function new(input string path = "transcation");
		super.new(path);
	endfunction
	
endclass

class generator extends uvm_sequence#(transcation);
`uvm_object_utils(generator)

	transcation tr;
	
	function new(input string path = "generator");
		super.new(path);
	endfunction
	
	virtual task body();
		repeat(15)
		begin
			tr = transcation::type_id::create("tr");
			start_item(tr);
			assert(tr.randomize());
			`uvm_info("seq",$sformatf("a = %0d, b = %0d, y = %0d",tr.a,tr.b,tr.y),UVM_NONE);
			finish_item(tr);
		end
	endtask
	
endclass

class drv extends uvm_driver#(transcation);
`uvm_component_utils(drv);

	transcation tr;
	virtual mul_intf mif;
	
	function new(input string path = "drv",uvm_component parent = null);
		super.new(path,parent);
	endfunction
	
	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db#(virtual mul_intf)::get(this,"","mif",mif))
			`uvm_error("drv","unable to access the interface");
	endfunction
	
	virtual task run_phase(uvm_phase phase);
		tr = transcation::type_id::create("tr");
		forever begin
			seq_item_port.get_next_item(tr);
			mif.a <= tr.a;
			mif.b <= tr.b;
			`uvm_info("drv",$sformatf("a = %0d, b = %0d, y = %0d",tr.a,tr.b,tr.y),UVM_NONE);
			seq_item_port.item_done();
			#20;
		end
	endtask
	
endclass

class mon extends uvm_monitor;
`uvm_component_utils(mon)

	uvm_analysis_port#(transcation) send;
	transcation tr;
	virtual mul_intf mif;

	function new(input string path = "mon",uvm_component parent);
		super.new(path,parent);
	endfunction
	
	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		
		tr = transcation::type_id::create("tr");
		if(!uvm_config_db#(virtual mul_intf)::get(this,"","mif",mif))
			`uvm_error("mon","Unablbe to access the interface");
		send = new("send",this);
	
	endfunction
	
	virtual task run_phase(uvm_phase phase);
	
		forever begin
			#20;
			tr.a <= mif.a;
			tr.b <= mif.b;
			tr.y <= mif.y;
			`uvm_info("mon",$sformatf("a = %pd, b = %0d, y = %0d",tr.a,tr.b,tr.y),UVM_NONE)
			send.write(tr);
		end
		
	endtask
	
endclass

class scb extends uvm_scoreboard;
`uvm_component_utils(scb)

	uvm_analysis_imp#(transcation,scb) recv;
	
	function new(input string path = "scb",uvm_component parent = null);
		super.new(path,parent);
	endfunction
	
	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		recv = new("recv",this);
	endfunction
	
	virtual function void write(transcation tr);
		if(tr.a * tr.b == tr.y)
			`uvm_info("scb",$sformatf("Test Passed -> a = %0d, b = %0d, y = %0d",tr.a,tr.b,tr.y),UVM_NONE)
		else 
			`uvm_error("scb",$sformatf("Test Failed -> a = %0d, b = %0d, y = %0d",tr.a,tr.b,tr.y))
		
		$display("-------------------------------------------------");
		
	endfunction
	
endclass

class agent extends uvm_agent;
`uvm_component_utils(agent)

	function new(input string path = "agent",uvm_component parent = null);
		super.new(path,parent);
	endfunction
	
	drv d;
	uvm_sequencer#(transcation) seqr;
	mon m;
	
	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		
		d = drv::type_id::create("d",this);
		seqr = uvm_sequencer#(transcation)::type_id::create("seqr",this);
		m = mon::type_id::create("m",this);
		
	endfunction
	
	virtual function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		d.seq_item_port.connect(seqr.seq_item_export);
	endfunction
	
endclass

class env extends uvm_env;
`uvm_component_utils(env);

	function new(input string path = "agent",uvm_component parent = null);
		super.new(path,parent);
	endfunction
	
	agent a;
	scb s;
	
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
`uvm_component_utils(test);

	function new(input string path = "test",uvm_component parent = null);
		super.new(path,parent);
	endfunction
	
	env e;
	generator gen;
	
	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		
		e = env::type_id::create("e",this);
		gen = generator::type_id::create("gen");
		
	endfunction
	
	virtual task run_phase(uvm_phase phase);
		phase.raise_objection(this);
		gen.start(e.a.seqr);
		#20;
		phase.drop_objection(this);
	endtask
	
endclass
			