class apb_monitor extends uvm_monitor;

	`uvm_component_utils(apb_monitor)
	
	virtual apb_if #(ADDR_WIDTH,DATA_WIDTH) vif;
	
	apb_seq_items seq_items_h;
	
	uvm_analysis_port #(apb_seq_items) an_port;

	function new(string name = "apb_monitor", uvm_component parent = null);
		super.new(name,parent);
	endfunction 
	
	function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      `uvm_info(get_type_name(),"inside build phase of monitor",UVM_NONE)
		if(!uvm_config_db #(virtual apb_if #(ADDR_WIDTH,DATA_WIDTH))::get(this,"","vif",vif)) begin
		`uvm_fatal("config_db","config_db is not get in monitor")
		end
      an_port = new("an_port",this);
	endfunction 
	
	task run_phase(uvm_phase phase);
      super.run_phase(phase);
		forever begin 
		//fork
			sample();
			an_port.write(seq_items_h);
		//join
		end 
	endtask 
	
	task sample();
		seq_items_h = apb_seq_items #(ADDR_WIDTH,DATA_WIDTH)::type_id::create("seq_items_h",this);
		// using clocking block of interface master monitor
      @(posedge vif.mon_cb);
		//sampling the signals from dut via virtual interface 
		seq_items_h.psel = vif.mon_cb.psel;
		seq_items_h.paddr = vif.mon_cb.paddr;
		seq_items_h.pwrite = vif.mon_cb.pwrite;
		seq_items_h.pwdata = vif.mon_cb.pwdata;
		seq_items_h.pstrb = vif.mon_cb.pstrb;
      	seq_items_h.penable = vif.mon_cb.penable;
		seq_items_h.prdata = vif.mon_cb.prdata;
      	seq_items_h.pslverr = vif.mon_cb.pslverr;
		if(vif.penable=='b1 && vif.pready=='b1) begin
          if(vif.psel=='b0) begin
          `uvm_error(get_type_name(), $sformatf("PSEL: psel low in between transaction psel=%0h",vif.psel)) 
        end
        end
      `uvm_info(get_type_name(),$sformatf("paddr = %0h \t pready = %0d \t pwdata = %0h \t prdata = %0h",vif.paddr,vif.pready,vif.pwdata,vif.prdata),UVM_NONE)
	endtask
endclass