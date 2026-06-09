module TB_alu;

	reg [15:0] inputA;
	reg [15:0] inputB;
	wire [15:0] outputB;
	wire LEQ;

	reg [15:0] exp_outputB; //expected output B to calculate results

ALU DUT(
	.inputA(inputA),
	.inputB(inputB),
	.outputB(outputB),
	.LEQ(LEQ)
);
	
	initial begin
	
	inputA = 16'hBBBB; //generic reset state to test subtraction
	inputB = 16'h1111;
	#1
	exp_outputB = inputB - inputA;
	#1;
	if (outputB !== exp_outputB)
	$display("FAIL case 1"); 
	if (LEQ !== ( (inputB - inputA == 0) || exp_outputB[15] ))
	$display("LEQ FAIL case 1");
	#1
	inputA = 16'h1111;
	inputB = 16'h1112; //check overflow detection
	#1
	exp_outputB = inputB - inputA;
	#1;
	if (outputB !== exp_outputB)
	$display("FAIL case 2"); 
	if (LEQ !== ( (inputB - inputA == 0) || exp_outputB[15] ))
	$display("LEQ FAIL case 2");
	#1
	inputA = 16'h1111;
	inputB = 16'h1111;
	#1
	exp_outputB = inputB - inputA;
	#1;
	if (outputB !== exp_outputB)
	$display("FAIL case 3"); 
	if (LEQ !== ( (inputB - inputA == 0) || exp_outputB[15] ))
	$display("LEQ FAIL case 3");
	#1
	inputA = 16'h7FFF;
	inputB = 16'h8000;
	#1
	exp_outputB = inputB - inputA;
	#1;
	if (outputB !== (exp_outputB))
	$display("FAIL case 4"); 
	if (LEQ !== ( (inputB - inputA == 0) || exp_outputB[15] ))
	$display("LEQ FAIL case 4");
	#1
	inputA = 16'h7FFF;
	inputB = 16'h0001;
	#1
	exp_outputB = inputB - inputA;
	#1;
	if (outputB !== exp_outputB)
	$display("FAIL case 5"); 
	if (LEQ !== ( (inputB - inputA == 0) || exp_outputB[15] ))
	$display("LEQ FAIL case 5");
	#1
	inputA = 16'h0000;
	inputB = 16'h0001;
	#1
	exp_outputB = inputB - inputA;
	#1;
	if (outputB !== exp_outputB)
	$display("FAIL case 6"); 
	if (LEQ !== ( (inputB - inputA == 0) || exp_outputB[15] ))
	$display("LEQ FAIL case 6");
	$finish;
	end
endmodule
