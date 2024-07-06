// Code your design here
module apb_design #(parameter ADDR_WIDTH = 32, DATA_WIDTH = 32)(pclk,prst,paddr,psel,penable,pwrite,pwdata,pstrb,pprot,pready,pslverr,prdata);

	//input signals
  	input  pclk;
  	input  prst;
	input  psel;
	input  penable;
	input  pwrite;
	input  [3:0] pstrb; // width of pstrb decide based on datawidth like 32 / 8 = 4
	input  [2:0] pprot;
	input  [ADDR_WIDTH - 1 : 0] paddr; // max 32 bits wide
	input  [DATA_WIDTH - 1 : 0] pwdata; // max 32 bits wide
	
	// output signals
	output reg pready;
	output reg pslverr;
	output reg  [DATA_WIDTH - 1 : 0] prdata; // max 32 bits wide
	
	// memory declaration
  reg [DATA_WIDTH : 0] mem [2**ADDR_WIDTH : 0];
 
	// state declerations
    reg [1:0] present_state,next_state;
	parameter idle = 2'b00;
	parameter setup = 2'b01;
	parameter access = 2'b10;
//   assign prdata = mem[paddr];
  
	always @(posedge pclk) begin 
		if(prst) begin 
			present_state <= idle;
			prdata <= 0;
		end
		else begin 
			present_state <= next_state;
		end
	end 
	
  always @(*) begin 
		if(prst) begin 
			pready <= 1'b0;
			//pslverr <= 1'b1;
		end
		else begin 
			case({psel,penable})
			2'b00 : pready <= 1'b0;
			2'b01 : pready <= 1'b0;
			2'b10 : pready <= 1'b0;
			2'b11 : pready <= 1'b1;
			default : pready <= 1'b0;
			endcase
		end 
	end 
	
	always @(*) begin // always@(*) here * means sensitivity list which means any signal got any change
	case(present_state)
		idle : if(psel && !penable) begin 
				next_state <= setup;
				end 
				else begin 
				next_state <= present_state;
				end 
		
		setup : if(psel && penable) begin 
					next_state <= access;
				end 
				else begin 
					next_state <= idle;
				end 
				
		access : if(psel && penable && pready) begin 
          if(pwrite == 1'b1) begin 
                     mem[paddr] <= pwdata;
						pslverr <= 1;
					end 
					else 
                      begin 
						prdata <= mem[paddr];
						pslverr <= 1;
					end 
				end
				else begin 
					next_state <= present_state;
					pready <= 0;
					pslverr <= 0;
				end
	endcase
	end 
	
  	initial begin 
      $monitor("from dut :::: paddr = %0h \t psel = %0d \t  pwdata = %0h \t prdata = %0h \tb pslverr = %0h \t mem = %0p",paddr,pready,pwdata,prdata,pslverr,mem);
    end 
  
/*	
	//////////Design Second////////////////
	
	reg [ADDR_WIDTH - 1 : 0] addr;
	reg [DATA_WIDTH - 1 : 0] mem [2**ADDR_WIDTH - 1 : 0];
	
	assign prdata = mem[addr];
	
	always @(*) begin 
		if (prst) begin 
			pready <= 0;
		end 
		else if (psel && !penable && !pwrite) begin 
			pready <= 0;
		end
		else if (psel && penable && !pwrite) begin
			pready <= 1;
			addr <= paddr;
		end 
		else if (psel && !penable && pwrite) begin 
			pready <= 0;
		end 
		else if (psel && penable && pwrite) begin 
			pready <= 1;
			mem[addr] <= pwdata;
		end
		else 
			pready <= 0;
	end
*/
	
endmodule 