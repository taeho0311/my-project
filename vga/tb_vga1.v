`timescale 1ns/1ps

module TB;

localparam CLK_HPER = 20;
localparam SIM_TIME = 800*525*5*CLK_HPER;

reg		CLK;
reg		RST;
wire		H_SYNC;
wire		V_SYNC;
wire		PIXEL;
wire	[18:0]	P_COUNT;

VGA640X480 VGA_640X480(
	.CLK(CLK),
	.RST(RST),
	.H_SYNC(H_SYNC),
	.V_SYNC(V_SYNC),
	.PIXEL(PIXEL),
	.P_COUNT(P_COUNT)
);

initial			CLK <= 1'b0;
always #(CLK_HPER)	CLK <= ~CLK;

initial
begin
	RST <= 1'b1;
	#(2*CLK_HPER);
	RST <= 1'b0;
end

initial
begin
	$dumpfile("tb.vcd");
	$dumpvars(0,TB);
	#(SIM_TIME);
	$finish();
end

endmodule
