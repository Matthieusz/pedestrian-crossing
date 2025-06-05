module mytestbenchmodule();
reg clk;
initial clk <= 0;
always #50  clk <= ~clk;
	
reg seed_stb;	
reg rst;
initial 
begin	 
	seed_stb <=0;
	rst <= 0;
	#100;	
	rst <= 1;
	#500;
	rst <= 0;
	#505;
	seed_stb <= 0;
	@(posedge clk);
	seed_stb <= 1;
	@(posedge clk);
	seed_stb <= 0;
end

random1 ran1(
	.RST(rst),
	.CLK(clk),
	.SEED_DAT(16'hCAFE),
	.SEED_STB(seed_stb),
	.ENABLE(1),
	.RANDOM_WORD()
);	
endmodule	
