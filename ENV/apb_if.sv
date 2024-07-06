interface apb_if #(parameter ADDR_WIDTH = 32, DATA_WIDTH = 32) (input bit pclk);
	
  logic prst;
  logic [ADDR_WIDTH - 1 : 0] paddr; // max 32 bits wide
  logic psel;
  logic penable;
  logic pwrite;
  logic [DATA_WIDTH - 1 : 0] pwdata; // max 32 bits wide
   logic [3:0] pstrb; // width of pstrb decide based on datawidth like 32 / 8 = 4
  logic [2:0] pprot;
  
  //NOTE : if we are taking logic here for below varialble then it will throw error. Most likely this is because someone has a continuous assignment to aready. Change the declaration to a wire.
  wire pready; 
  wire [DATA_WIDTH - 1 : 0] prdata; // max 32 bits wide
  wire pslverr;
  
  //For master driver 
  clocking mdrv_cb @(posedge pclk);
	default input #1 output #1;
    input prst;
    output paddr, psel, penable, pwrite, pwdata;
    input  prdata,pslverr,pready;
  endclocking: mdrv_cb
  
  //For master monitor 
  clocking mon_cb @(posedge pclk);
	default input #1 output #1;
    input prst;
    input paddr,psel,pwrite,pwdata,pstrb,prdata,penable,pslverr,pready;
  endclocking: mon_cb
/*
  //slave driver clocking block 
  clocking sdrv_cb @(posedge pclk);
	 default input #1 output #1;
     input prst;
     input  paddr, psel, penable, pwrite, pwdata;
     output prdata, pready, pslverr;
  endclocking: sdrv_cb

  //slave monitor  clocking block
  clocking smon_cb @(posedge pclk);
	 default input #1 output #1;
     input paddr, psel, penable, pwrite, prdata, pwdata;
  endclocking: smon_cb
*/
  //modport blocks 
  modport mdrv_mp (clocking mdrv_cb);
  modport mon_mp (clocking mon_cb);
  //modport sdrv_mp (clocking sdrv_cb);
//  modport smon_mp (clocking smon_cb);

endinterface


