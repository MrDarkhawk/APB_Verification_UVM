class apb_coverage extends uvm_subscriber;


	`uvm_component_utils(apb_coverage)

	`uvm_analysis_imp #(apb_seq_items #(ADDR_WIDTH,DATA_WIDTH),apb_coverage) an_imp;

	virtual apb_if vif;

	apb_seq_items seq_items_h;
	
	real dpram_cov;

	covergroup apb_cg @(posedge vif.clk);
		
		option.per_instance = 1;
		option.goal = 100;
		option.name = "coverage";
		
		psel_cp :	coverpoint seq_items_h.psel {bins psel_b1 inside {0,1};}
		
		paddr_cp :	coverpoint seq_items_h.paddr {bins paddr_b1 = {[0:255]};
												  bins paddr_b2 = {[256:65535]};
												  bins paddr_b3 = {[65536:4294967295]};}
		
		pwrite_cp :	coverpoint seq_items_h.pwrite {bins pwrite_b1 = {0,1};}
		
		pwdata_cp :	coverpoint seq_items_h.pwdata {bins pwdata_b1 = {[0:255]};
												   bins pwdata_b2 = {[256:65535]};
												   bins pwdata_b3 = {[65536:4294967295]};}
	
		penable_cp : coverpoint seq_items_h.penable {bins penable_b1 = {0,1};}
		
		pready_cp: coverpoint seq_items_h.pready {bins pready_b1 = {0,1};}
		
		pslverr_cp : coverpoint seq_items_h.pslverr {bins pslverr_b1 = {0,1};}
		
		prdata_cp :	coverpoint seq_items_h.prdata {bins prdata_b1 = {[0:255]};
												   bins prdata_b2 = {[256:65535]};
												   bins prdata_b3 = {[65536:4294967295]};}
												   					
	
	
	endgroup 
	
	// constructor 
	function new(string name = "apb_coverage",uvm_component parent = null);
		super.new(name,parent);
		apb_cg = new(); // to create the coevergroup 
	endfunction 
		
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		an_imp = new("an_imp",this); // creating analysis implication port
	endfunction
	
	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		forever begin 
		an_imp.get(seq_items_h); //getting sequence items from monitor 
		apb_cg.sample(); // sampling the covergroup 
		end
	endtask
	
	function void extract_phase(uvm_phase phase);
		super.extract_phase(phase);
		apb_cov = apb_cg.get_coverage(); //retrieve and process the information from functional coverage monitors 
	endfunction
	
	function void report_phase(uvm_phase phase);
		super.report_phase(phase);
		`uvm_info("coverage_info","apb_coverage report_phase started",UVM_MEDIUM)
		`uvm_info(get_type_name(),$sformatf("APB coverage is : %f",apb_cov),UVM_MEDIUM)
	endfunction
endclass 
