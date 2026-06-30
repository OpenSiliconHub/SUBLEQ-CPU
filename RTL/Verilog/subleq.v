module subleq
  #(
    parameter G_RESET_ACTIVE_STATE = 1'b0,
    parameter G_DATA_WIDTH         = 10,
    parameter G_ADDR_WIDTH         = 10
    )
  (
   input wire                        i_clk,
   input wire                        i_rst_n,
   output reg [G_ADDR_WIDTH - 1 : 0] o_pc_debug
   );

  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  // u_single_port_ram
  wire [G_DATA_WIDTH - 1 : 0] mem_data;

  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  // subleq_proc
  localparam [3:0]            RESET        = 4'h0,
                              FETCH_A      = 4'h1,
                              FETCH_B      = 4'h2,
                              FETCH_C      = 4'h3,
                              FETCH_DATA_A = 4'h4,
                              FETCH_DATA_B = 4'h5,
                              SUBTRACT     = 4'h6,
                              WRITEBACK    = 4'h7,
                              BRANCH_CHECK = 4'h8;
  reg [3:0]                   state;

  reg [G_ADDR_WIDTH - 1 : 0]  pc;
  reg [G_ADDR_WIDTH - 1 : 0]  ir_a;
  reg [G_ADDR_WIDTH - 1 : 0]  ir_b;
  reg [G_ADDR_WIDTH - 1 : 0]  ir_c;
  reg [G_DATA_WIDTH - 1 : 0]  data_a;
  reg [G_DATA_WIDTH - 1 : 0]  data_b;
  reg                         subleq_we;
  reg [G_ADDR_WIDTH - 1 : 0]  subleq_addr;
  reg [G_DATA_WIDTH - 1 : 0]  subleq_data;



  wire [G_DATA_WIDTH - 1 : 0] diff;
  wire                        ovf;
  wire                        sign;
  wire                        leq_condition;

  localparam MSB = $bits(data_a) - 1;

  assign diff          = data_b - data_a;
  assign ovf           = (data_a[MSB] ^ data_b[MSB]) & (data_b[MSB] ^ diff[MSB]);
  assign sign          = diff[MSB];
  assign leq_condition = (diff ==  {G_DATA_WIDTH{1'b0}}) || (sign ^ ovf);

  // Memory
  single_port_ram
    #(
      .G_DATA_WIDTH(G_DATA_WIDTH),
      .G_ADDR_WIDTH(G_ADDR_WIDTH)
      )
  u_single_port_ram
    (
     .i_clk(i_clk),
     .i_we(subleq_we),
     .i_addr(subleq_addr),
     .i_data(subleq_data),
     .o_data(mem_data)
     );

  // Continuous Debug Output
  always @(*) begin
    o_pc_debug <= pc;
  end

  always @(posedge i_clk) begin
    if (i_rst_n == G_RESET_ACTIVE_STATE) begin
      state    <= RESET;
      pc       <= {G_DATA_WIDTH{1'b0}};
    end else begin
      // Default: Keep write enable off unless explicitly turned on
      subleq_we <= 1'b0;

      case (state)
        RESET: begin
          pc    <= {G_DATA_WIDTH{1'b0}};
          state <= FETCH_A;
        end

        FETCH_A: begin
          subleq_addr <= pc;        // 1. Tell memory to fetch address A
          state    <= FETCH_B;      // 2. Move to next state
        end

        FETCH_B: begin
          subleq_addr <= pc + 16'd1;  // 1. Tell memory to fetch address B
          ir_a     <= mem_data;    // 2. Capture data requested in previous state (Address A)
          state    <= FETCH_C;
        end

        FETCH_C: begin
          subleq_addr <= pc + 16'd2;  // 1. Tell memory to fetch address C
          ir_b     <= mem_data;    // 2. Capture data requested in previous state (Address B)
          state    <= FETCH_DATA_A;
        end

        FETCH_DATA_A: begin
          subleq_addr <= ir_a;        // 1. Tell memory to look up the data stored inside Address A
          ir_c     <= mem_data;    // 2. Capture data requested in previous state (Address C)
          state    <= FETCH_DATA_B;
        end

        FETCH_DATA_B: begin
          subleq_addr <= ir_b;        // 1. Tell memory to look up the data stored inside Address B
          data_a   <= mem_data;    // 2. Capture actual Data A
          state    <= SUBTRACT;
        end

        SUBTRACT: begin
          data_b   <= mem_data;    // 1. Capture actual Data B
          state    <= WRITEBACK;   // 2. Let the signals settle for calculation
        end

        WRITEBACK: begin
          subleq_addr <= ir_b;        // 1. Point memory back to target address B
          subleq_data <= diff;        // 2. Pass the ALU subtraction result
          subleq_we  <= 1'b1;        // 3. Turn on Write Enable so it saves on the NEXT clock edge
          state      <= BRANCH_CHECK;
        end

        BRANCH_CHECK: begin
          // 1. Evaluate our branch condition
          if (leq_condition) begin
            pc <= ir_c;          // Jump met: Update PC to target address C
          end else begin
            pc <= pc + 16'd3;    // Jump failed: Skip forward to the next instruction block
          end

          // 2. Automatically queue up the first fetch of the NEXT loop iteration right now!
          subleq_addr <= (leq_condition) ? ir_c : (pc + 16'd3);
          state    <= FETCH_B;     // We skip FETCH_A because we just handled setting up the address!
        end

        default: begin
          state <= RESET;
        end
      endcase
    end
  end

endmodule
