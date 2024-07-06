class apb_driver extends uvm_driver #(apb_seq_items #(ADDR_WIDTH,DATA_WIDTH));

	`uvm_component_utils(apb_driver)
	
	apb_seq_items seq_items_h;
	
  virtual apb_if#(ADDR_WIDTH,DATA_WIDTH) vif;
	
	function new(string name = "apb_driver", uvm_component parent = null);
		super.new(name,parent);
	endfunction 

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
      `uvm_info(get_type_name(),"inside build phase",UVM_NONE)
	endfunction
		
	task run_phase(uvm_phase phase);
      super.run_phase(phase);
      `uvm_info(get_type_name(),"inside run phase",UVM_NONE)
		forever begin
			seq_item_port.get_next_item(req);
			send_to_dut(req);
			seq_item_port.item_done();
		end 
      `uvm_info(get_type_name(),$sformatf("paddr = %0h \t pwdata = %0h ",vif.paddr,vif.pwdata),UVM_NONE)
	endtask 
	
	task send_to_dut(apb_seq_items req);
		if(!vif.prst) begin 
			@(vif.mdrv_cb);
			vif.paddr <= req.paddr;
			vif.psel <= req.psel;
			vif.pwrite <= req.pwrite;
        if(req.pwrite == 1)
			vif.pwdata <= req.pwdata;
		else vif.pwdata <= 'b0;
		end 
		// for reset scenario 
		if(vif.prst) begin 
			vif.psel <= 0;
			vif.paddr <=0;  
			vif.pwdata <=0;
			vif.penable <= 0;
			vif.pwrite <= 0;
		end 
		// penable must assert after write == 1;
		if(req.pwrite == 1) begin 
			@(vif.mdrv_cb)
			vif.penable <= req.penable;
		end 
      `uvm_info(get_type_name(),$sformatf("paddr = %0h \t pwdata = %0h \t psel = %0h \t pwrite = %0h",vif.paddr,vif.pwdata,vif.psel,vif.pwrite),UVM_NONE)
	endtask 	
endclass