module TB;

localparam CLK_HPER = 5;
localparam SIM_TIME = 2*40*CLK_HPER;

reg		CLK;
reg		RST;
reg		CS;
reg		wr_en;
reg	[7:0]	wr_din;
reg	[3:0]	wr_cin;
wire	[7:0]	rd_out;

DECODING #(8,4,8,3) DECO_8x8 (
	.CLK(CLK),
	.RST(RST),
	.CS(CS),
	.wr_en(wr_en),
	.wr_din(wr_din),
	.wr_cin(wr_cin),
	.rd_out(rd_out)
);

initial			CLK <= 1'b0;
always #(CLK_HPER)	CLK <= ~CLK;

initial
begin
	RST <= 1'b1;
	CS <= 1'b0;
	wr_en <= 1'b0;
	wr_din <= 8'd0;
	wr_cin <= 4'd0;
	
	#(2*CLK_HPER);
	RST <= 1'b0;
	CS <= 1'b1;
	wr_en <= 1'b1;
	
	#(2*CLK_HPER);
	wr_din <= 8'd97;
	wr_cin <= 4'd3;
	
	#(2*CLK_HPER);
	wr_din <= 8'd98;
	wr_cin <= 4'd2;
	
	#(2*CLK_HPER);
	wr_din <= 8'd99;
	wr_cin <= 4'd1;
	
	#(2*CLK_HPER);
	wr_din <= 8'd100;
	wr_cin <= 4'd4;
	
	#(2*CLK_HPER);
	wr_din <= 8'd101;
	wr_cin <= 4'd2;
	
	#(2*CLK_HPER);
	wr_din <= 8'd99;
	wr_cin <= 4'd5;

	#(2*CLK_HPER);
	wr_din <= 8'd100;
	wr_cin <= 4'd4;
	
	#(2*CLK_HPER);
	wr_din <= 8'd97;
	wr_cin <= 4'd3;

	#(2*CLK_HPER);
	wr_en <= 1'b0;

end

initial
begin
	$dumpfile("tb.vcd");
	$dumpvars(0,TB);
	#(SIM_TIME);
	$finish();
end

endmodule
