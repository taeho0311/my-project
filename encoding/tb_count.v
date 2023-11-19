module TB;

localparam CLK_HPER = 5;
localparam SIM_TIME = 2*20*CLK_HPER;

reg		CLK;
reg		RST;
reg	[7:0]	IN;
wire	[7:0]	DATA;
wire	[2:0]	COUNT;
wire		VAILD;

COUNT COUNT0 (
	.CLK(CLK),
	.RST(RST),
	.IN(IN),
	.DATA(DATA),
	.COUNT(COUNT),
	.VAILD(VAILD)
);

initial			CLK <= 1'b0;
always #(CLK_HPER)	CLK <= ~CLK;

initial
begin
	RST <= 1'b1;
	#(2*CLK_HPER);
	RST <= 1'b0;

	#(2*CLK_HPER);
	IN <= 8'd99;
	#(4*CLK_HPER);
	IN <= 8'd97;
	#(6*CLK_HPER);
	IN <= 8'd98;
	#(2*CLK_HPER);
	IN <= 8'd100;
	#(4*CLK_HPER);
	IN <= 8'd99;
end

initial
begin
	$dumpfile("tb.vcd");
	$dumpvars(0,TB);
	#(SIM_TIME);
	$finish();
end

endmodule
