module UnifiedMemory (
    input  wire        clk,
    input  wire        we,       // write enable
    input  wire [15:0] addr,     // 16-bit address
    input  wire [15:0] din,      // data input
    output reg  [15:0] dout      // data output (now registered!)
);

    // 64K x 16-bit memory 
    reg [15:0] mem [0:65535];

    // Read & Write operations both happen on the clock edge (True BRAM Inference)
    always @(posedge clk) begin
        if (we) begin
            mem[addr] <= din;
        end
        dout <= mem[addr]; // Synchronous read
    end

    // Preload program/data from file for FPGA initialization
    initial begin
        $readmemh("program.hex", mem);
    end

endmodule
