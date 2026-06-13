module SUBLEQ_CPU (
    input wire clk,
    input wire rst_n,

    output reg [15:0] pc_debug
);
    // Standard states
    localparam [3:0] RESET        = 4'h0,
                     FETCH_A      = 4'h1,
                     FETCH_B      = 4'h2,
                     FETCH_C      = 4'h3,
                     FETCH_DATA_A = 4'h4,
                     FETCH_DATA_B = 4'h5,
                     SUBTRACT     = 4'h6,
                     WRITEBACK    = 4'h7,
                     BRANCH_CHECK = 4'h8;

    reg [3:0]  state;
    reg [15:0] pc;
    reg [15:0] ir_a, ir_b, ir_c;
    reg [15:0] data_a, data_b;

    reg [15:0] mem_addr;
    reg [15:0] mem_din;
    reg        mem_we;
    wire [15:0] mem_dout;

    wire [15:0] diff;
    wire        ovf;
    wire        sign;
    wire        leq_condition;

    assign diff          = data_b - data_a;
    assign ovf           = (data_a[15] ^ data_b[15]) & (data_b[15] ^ diff[15]);
    assign sign          = diff[15];
    assign leq_condition = (diff == 16'd0) || (sign ^ ovf);

    // Instantiation of Synchronous Unified Memory
    UnifiedMemory u_memory (
        .clk(clk),
        .we(mem_we),
        .addr(mem_addr),
        .din(mem_din),
        .dout(mem_dout)
    );

    // Continuous Debug Output
    always @(*) begin
        pc_debug = pc;
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            pc       <= 16'h0;
            state    <= RESET;
            ir_a     <= 16'h0;
            ir_b     <= 16'h0;
            ir_c     <= 16'h0;
            data_a   <= 16'h0;
            data_b   <= 16'h0;
            mem_we   <= 1'b0;
            mem_addr <= 16'h0;
            mem_din  <= 16'h0;
        end else begin
            // Default: Keep write enable off unless explicitly turned on
            mem_we <= 1'b0;

            case (state)
                RESET: begin
                    pc    <= 16'h0;
                    state <= FETCH_A;
                end

                FETCH_A: begin
                    mem_addr <= pc;          // 1. Tell memory to fetch address A
                    state    <= FETCH_B;     // 2. Move to next state
                end

                FETCH_B: begin
                    mem_addr <= pc + 16'd1;  // 1. Tell memory to fetch address B
                    ir_a     <= mem_dout;    // 2. Capture data requested in previous state (Address A)
                    state    <= FETCH_C;
                end

                FETCH_C: begin
                    mem_addr <= pc + 16'd2;  // 1. Tell memory to fetch address C
                    ir_b     <= mem_dout;    // 2. Capture data requested in previous state (Address B)
                    state    <= FETCH_DATA_A;
                end

                FETCH_DATA_A: begin
                    mem_addr <= ir_a;        // 1. Tell memory to look up the data stored inside Address A
                    ir_c     <= mem_dout;    // 2. Capture data requested in previous state (Address C)
                    state    <= FETCH_DATA_B;
                end

                FETCH_DATA_B: begin
                    mem_addr <= ir_b;        // 1. Tell memory to look up the data stored inside Address B
                    data_a   <= mem_dout;    // 2. Capture actual Data A
                    state    <= SUBTRACT;
                end

                SUBTRACT: begin
                    data_b   <= mem_dout;    // 1. Capture actual Data B
                    state    <= WRITEBACK;   // 2. Let the signals settle for calculation
                end

                WRITEBACK: begin
                    mem_addr <= ir_b;        // 1. Point memory back to target address B
                    mem_din  <= diff;        // 2. Pass the ALU subtraction result
                    mem_we   <= 1'b1;        // 3. Turn on Write Enable so it saves on the NEXT clock edge
                    state    <= BRANCH_CHECK;
                end

                BRANCH_CHECK: begin
                    // 1. Evaluate our branch condition
                    if (leq_condition) begin
                        pc <= ir_c;          // Jump met: Update PC to target address C
                    end else begin
                        pc <= pc + 16'd3;    // Jump failed: Skip forward to the next instruction block
                    end

                    // 2. Automatically queue up the first fetch of the NEXT loop iteration right now!
                    mem_addr <= (leq_condition) ? ir_c : (pc + 16'd3);
                    state    <= FETCH_B;     // We skip FETCH_A because we just handled setting up the address!
                end

                default: begin
                    state <= RESET;
                end
            endcase
        end
    end

endmodule

