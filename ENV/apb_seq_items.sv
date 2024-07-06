class apb_seq_items #(parameter ADDR_WIDTH = 32, DATA_WIDTH = 32)extends uvm_sequence_item;

	rand  bit psel;
	rand  bit penable;
	rand bit pwrite ;
  	rand bit [ADDR_WIDTH - 1 : 0] paddr;
  	rand bit [DATA_WIDTH - 1 : 0] pwdata;
	rand bit [3:0] pstrb;
	rand bit [2:0] pprot;
  	bit [DATA_WIDTH - 1:0] prdata;
  	bit pready;
  	bit pslverr;
	
  constraint psel_c {psel inside {1};}
  
  constraint penable_c {penable inside {1};}
  
  constraint paddr_limit { paddr <= 31; }
  
  `uvm_object_param_utils_begin(apb_seq_items #(ADDR_WIDTH,DATA_WIDTH))
		`uvm_field_int (psel,UVM_ALL_ON)
		`uvm_field_int (penable,UVM_ALL_ON)
		`uvm_field_int (pwrite,UVM_ALL_ON)
		`uvm_field_int (paddr,UVM_ALL_ON)
		`uvm_field_int (pwdata,UVM_ALL_ON)
		`uvm_field_int (pstrb,UVM_ALL_ON)
		`uvm_field_int (pprot,UVM_ALL_ON)
 		`uvm_field_int (prdata,UVM_ALL_ON)
  		`uvm_field_int (pready,UVM_ALL_ON)
  		`uvm_field_int (pslverr,UVM_ALL_ON)
	`uvm_object_utils_end

	function new(string name = "apb_seq_items");
		super.new(name);
	endfunction

endclass
