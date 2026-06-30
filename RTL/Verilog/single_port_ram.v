module single_port_ram
  #(
    parameter G_DATA_WIDTH = 16,
    parameter G_ADDR_WIDTH = 16
    )
  (
   input wire                        i_clk,
   input wire                        i_we,
   input wire [G_ADDR_WIDTH - 1 : 0] i_addr,
   input wire [G_DATA_WIDTH - 1 : 0] i_data,
   output reg [G_DATA_WIDTH - 1 : 0] o_data
   );

  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  // Memory
  reg [G_DATA_WIDTH - 1 : 0] ram_block [0 : (2 ** G_ADDR_WIDTH) - 1];

  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  // init_ram_proc
  // Preload program/data from file for FPGA initialization
  integer ii;
  initial begin
     for (ii = 0; ii < 2 ** G_ADDR_WIDTH; ii = ii + 1) begin
        ram_block[ii] = {G_DATA_WIDTH{1'b0}};
     end
     //$readmemh("program.hex", ram_block);
  end

  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  // mem_proc
  // Always output data from i_addr
  always @(posedge i_clk) begin : mem_proc
    if (i_we) begin
      ram_block[i_addr] <= i_data;
    end

    o_data <= ram_block[i_addr];

  end

  // Preload program/data from file for FPGA initialization
  //integer ii;
  //initial begin
  //   for (ii = 0; ii < 2 ** G_ADDR_WIDTH; ii = ii + 1) begin
  //      ram_block[ii] = 16'h0000;
  //   end
  //   $readmemh("program.hex", ram_block);
  //end

endmodule
