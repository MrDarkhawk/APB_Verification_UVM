
import uvm_pkg::*;
import apb_pkg::*;
// If wanna run in eda then include files of pkg.

module apb_top();
  	//int no_of_transfer = 10;

	bit pclk;
	bit prst;
	
	apb_if #(ADDR_WIDTH, DATA_WIDTH) inf(pclk);
	
  apb_design #(ADDR_WIDTH,DATA_WIDTH) dut(.pclk(pclk),.prst(inf.prst),.paddr(inf.paddr),.psel(inf.psel),.penable(inf.penable),.pwrite(inf.pwrite),.pwdata(inf.pwdata),.pstrb(inf.pstrb),.pprot(inf.pprot),.pready(inf.pready),.pslverr(inf.pslverr),.prdata(inf.prdata));

  always begin
		#5 pclk = ~pclk;
//       $display("Inside the clk block = %0d",pclk);
	end 
		
	initial begin 
      @(posedge pclk)
		inf.prst = 1;
      @(posedge pclk)
		inf.prst = 0;
	end 

	initial begin 
		uvm_config_db #(virtual apb_if #(ADDR_WIDTH, DATA_WIDTH)) :: set(null,"*","vif",inf);
		run_test("apb_base_test");
	end 
	initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
    end
endmodule
