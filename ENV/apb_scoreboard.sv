class apb_scoreboard extends uvm_scoreboard;

	`uvm_component_utils(apb_scoreboard)
	
	apb_seq_items seq_items_h;
	
	`uvm_analysis_imp #(apb_seq_items #(ADDR_WIDTH, DATA_WIDTH),apb_scoreboard) an_imp;
	
	//declaring queue 
	apb_seq_items seq_items_q[$];
	
	bit [DATA_WIDTH - 1:0] ref_data [ADDR_WIDTH - 1:0];
	bit [DATA_WIDTH - 1:0] exptd_data;
	
	function new(string name = "apb_scoreboard", uvm_component parent = null);
		super.new(name,parent);
		an_imp = new("an_imp",this);
	endfunction 
	
	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		
	endtask

	task ref_data();

	endtask	

	task check_data();

	endtask
endclass 
