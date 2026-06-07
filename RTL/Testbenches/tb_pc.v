module PC_tb;

	reg clk;
	reg rst;
	reg en;
	reg jump;
	reg [15:0]jump_addr;
	wire [15:0]pc;
PC dut(
	.clk(clk),
	.rst(rst),
	.en(en),
	.jump(jump),
	.jump_addr(jump_addr),
	.pc(pc)
);
	always #5 clk = ~clk; //clk inversion every 5 seconds
	initial begin
		clk = 0; //test reset
		rst = 1;
		en = 0;
		jump = 0;
		jump_addr = 0;
		#10
		rst = 0; //test increment (nothing should happen)
		en = 0;
		jump = 0;
		jump_addr = 0;
		#10
		en = 1; //test increment (should increment)
		#10
		en = 0; //test jump
		jump = 1;
		jump_addr = 16'hAABB;
		#30
		
	$finish;
	end

endmodule
