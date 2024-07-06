class apb_read_seqs extends uvm_sequence #(apb_seq_items #(ADDR_WIDTH,DATA_WIDTH));

	`uvm_object_utils(apb_read_seqs)
	
	apb_seq_items seq_items_h;
	
	function new(string name = "apb_read_seqs");
		super.new(name);
	endfunction 
		
	task body();
      repeat(`no_of_transfer) begin
			seq_items_h = apb_seq_items#(ADDR_WIDTH,DATA_WIDTH)::type_id::create("seq_items_h");
			start_item(seq_items_h);
          assert(seq_items_h.randomize() with {pwrite == 0;
                                              	psel == 1;});
			finish_item(seq_items_h);
			end
	endtask 
endclass 