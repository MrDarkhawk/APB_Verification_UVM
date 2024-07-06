class apb_agent extends uvm_agent;

  `uvm_component_utils(apb_agent)
	
	apb_monitor mon_h;
	apb_driver drv_h;
	apb_sequencer seqr_h;
	
	// declaring virtual interface which is used to make connect from dynamic component to static component
  virtual apb_if #(ADDR_WIDTH,DATA_WIDTH) vif;
   
   function new (string name = "apb_agent", uvm_component parent=null);
		super.new(name,parent);
   endfunction
   
   function void build_phase (uvm_phase phase);
		super.build_phase(phase);
		drv_h = apb_driver::type_id::create("drv_h",this);
		seqr_h = apb_sequencer::type_id::create("seqr_h",this);
		mon_h = apb_monitor::type_id::create("mon_h",this);
		//config db not get vif 
     if(!uvm_config_db #(virtual apb_if #(ADDR_WIDTH,DATA_WIDTH))::get(this,"","vif",vif)) begin
		`uvm_fatal("FIFO_WRITE_AGENT","The virtual interface get failed");	
		end
   endfunction
   
	function void connect_phase(uvm_phase phase); 
		drv_h.seq_item_port.connect(seqr_h.seq_item_export); 
		drv_h.vif = vif;
		mon_h.vif = vif;
	endfunction 
endclass