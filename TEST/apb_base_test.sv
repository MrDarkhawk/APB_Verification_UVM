class apb_base_test extends uvm_test ;

	// factory registration
	`uvm_component_utils(apb_base_test)
	
	//create handles 
	apb_env env_h;
	apb_write_seqs wseqs_h;
	apb_read_seqs rseqs_h;

	virtual apb_if vif;
	
	function new(string name = "apb_base_test", uvm_component parent = null);
		super.new(name,parent);
	endfunction 
	
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		env_h = apb_env::type_id::create("apb_h",this);
		wseqs_h = apb_write_seqs::type_id::create("wseqs_h",this);
		rseqs_h = apb_read_seqs::type_id::create("rseqs_h",this);
		uvm_config_db #(virtual apb_if #(ADDR_WIDTH,DATA_WIDTH))::get(null,"","vif",vif);
	endfunction

	function void end_of_elaboration_phase(uvm_phase phase);
		super.end_of_elaboration_phase(phase);
		uvm_top.print_topology();	
	endfunction
	
  task run_phase(uvm_phase phase);
		phase.raise_objection(this);
    `uvm_info(get_type_name(),$sformatf("inside run phase prst = %0d Before wait for reset",vif.prst),UVM_NONE)
    	wait(vif.prst == 0);
    `uvm_info(get_type_name(),$sformatf("inside run phase prst = %0d After wait for reset",vif.prst),UVM_NONE)
    		wseqs_h.start(env_h.agent_h.seqr_h);
			//rseqs_h.start(env_h.agent_h.seqr_h);
		phase.drop_objection(this);		
	endtask 
endclass 
