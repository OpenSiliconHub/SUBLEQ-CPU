module UnifiedMemory (
    input  wire        clk,
    input  wire        we,        // write enable
    input  wire [15:0] addr,      // 16-bit address
    input  wire [15:0] din,       // data input
    output reg  [15:0] dout       // data output
);

    // 64K x 16-bit memory 
    reg [15:0] mem [0:65535];

    // Read operation (combinational)
    always @(*) begin
        dout = mem[addr];
    end

    // Write operation (synchronous)
    always @(posedge clk) begin
        if (we) begin
            mem[addr] <= din;
        end
    end

    // Optional: preload program/data from file
    initial begin
        // Example: load hex file into memory
        // $readmemh("program.hex", mem);
    end

endmodule
