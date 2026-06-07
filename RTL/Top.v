module SUBLEQ_CPU(
    input  wire clk,
    input  wire reset
);

    // -------------------------
    // Program Counter signals
    // -------------------------
    reg        en;          // enable increment
    reg        jump;        // jump control
    reg [15:0] jump_addr;   // jump target
    wire [15:0] pc;         // current PC value

    // Instantiate PC
    PC pc_inst (
        .clk(clk),
        .rst(reset),
        .en(en),
        .jump(jump),
        .jump_addr(jump_addr),
        .pc(pc)
    );

    // -------------------------
    // Unified Memory signals
    // -------------------------
    reg        mem_we;       // write enable
    reg [15:0] mem_addr;     // memory address
    reg [15:0] mem_din;      // data input
    wire [15:0] mem_dout;    // data output

    // Instantiate UnifiedMemory
    UnifiedMemory mem_inst (
        .clk(clk),
        .we(mem_we),
        .addr(mem_addr),
        .din(mem_din),
        .dout(mem_dout)
    );

    // -------------------------
    // Placeholder connections
    // -------------------------
    // For now, just tie memory address to PC output.
    // You’ll expand this later with IR and control logic.
    always @(*) begin
        mem_addr = pc;
        mem_we   = 1'b0;   // no writes yet
        mem_din  = 16'd0;  // unused
        en       = 1'b1;   // keep PC incrementing
        jump     = 1'b0;   // no jumps yet
        jump_addr= 16'd0;
    end

endmodule
