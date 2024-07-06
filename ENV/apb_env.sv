class apb_env extends uvm_env;

	`uvm_component_utils(apb_env)
	
	apb_agent	agent_h;
	apb_scoreboard	sb_h;
	apb_coverage	cov_h;
   
   function new (string name = "apb_env", uvm_component parent=null);
		super.new(name,parent);
   endfunction
   
	function void build_phase (uvm_phase phase);
		super.build_phase(phase);
		agent_h = apb_agent::type_id::create("agent_h",this);
		sb_h = apb_scoreboard::type_id::create("sb_h",this);
		cov_h = apb_coverage::type_id::create("cov_h",this);
	endfunction
   
	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		agent_h.mon_h.an_port.connect(sb_h.an_imp); // implication or fifo export 
		agent_h.mon_h.an_port.connect(cov_h.an_imp); 
	endfunction  
endclass 
