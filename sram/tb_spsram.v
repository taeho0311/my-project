module TB;

localparam CLK_HPER = 5;
localparam SIM_TIME = 2*20*CLK_HPER;

reg		CLK;
reg		CS;
reg		WE;
reg	[1:0]	A;
reg	[7:0]	DI;
wire	[7:0]	DO;

SPSRAM #(8,4,2,2,"init.hex") SPSRAM_8x4 (
	.CLK(CLK),
	.CS(CS),
	.WE(WE),
	.A(A),
	.DI(DI),
	.DO(DO)
);

initial			CLK <= 1'b0;
always	#(CLK_HPER)	CLK <= ~CLK;

initial
begin
	CS <= 1'b0;
	WE <= 1'b0;
	A  <= 2'b00;
	DI <= 16'hFF;

	#(2*CLK_HPER);
	A  <= 2'b01;

	#(2*CLK_HPER);
	CS <= 1'b1;
	WE <= 1'b1;
	A  <= 2'b00;
	DI <= 16'hAA;

	#(2*CLK_HPER);
	A  <= 2'b01;
	DI <= 16'hBB;
	#(2*CLK_HPER);
	A  <= 2'b10;
	DI <= 16'hEE;

	#(2*CLK_HPER);
	WE <= 1'b0;
	A  <= 2'b00;

	#(2*CLK_HPER);
	A  <= 2'b01;
	
	#(2*CLK_HPER);
	A  <= 2'b11;

	#(2*CLK_HPER);
	A  <= 2'b10;
end

initial
begin
	$dumpfile("tb.vcd");
	$dumpvars(0,TB);
	#(SIM_TIME);
	$finish();
end

endmodule
