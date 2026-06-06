module ALU (
    input  wire [15:0] inputA,
    input  wire [15:0] inputB,
  
    output reg  [15:0] outputB,
    output reg         LEQ
);
    wire [15:0] diff;
    wire        ovf;
    wire        sign;

    // Perform subtraction: B - A
    assign diff = inputB - inputA;

    // Overflow detection for subtraction
    // ovf = (A[15] ^ B[15]) & (B[15] ^ diff[15])
    assign ovf  = (inputA[15] ^ inputB[15]) & (inputB[15] ^ diff[15]);

    // Sign bit of result
    assign sign = diff[15];

    always @(*) begin
        outputB = diff;
      
        if (diff == 16'd0 || (sign ^ ovf))
            LEQ = 1'b1;
        else
            LEQ = 1'b0;
    end

endmodule
