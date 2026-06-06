module PC (
    input  wire        clk,
    input  wire        rst,
    input  wire        en,
    input  wire        jump,
  input  wire [15:0]   jump_addr,
    output reg  [15:0] pc
);

  always @(posedge clk or posedge rst) begin
    if (rst)
        pc <= 16'h0000;
    else if (jump)
        pc <= jump_addr;    
    else if (en)
        pc <= pc + 16'd3;      // PC = PC + 3
end

endmodule
