module InstructionRegister (
    input  wire        clk,
    input  wire        rst,
    input  wire [15:0] mem_dout,   // data from memory
    input  wire [1:0]  sel,        // which operand to latch (0=A,1=B,2=C)
    input  wire        load,       // load enable
    output reg  [15:0] IR_A,
    output reg  [15:0] IR_B,
    output reg  [15:0] IR_C
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            IR_A <= 16'd0;
            IR_B <= 16'd0;
            IR_C <= 16'd0;
        end else if (load) begin
            case (sel)
                2'd0: IR_A <= mem_dout;
                2'd1: IR_B <= mem_dout;
                2'd2: IR_C <= mem_dout;
            endcase
        end
    end
endmodule
