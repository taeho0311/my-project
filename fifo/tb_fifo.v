module TB;

localparam CLK_HPER = 5;
localparam SIM_TIME = 20*5*CLK_HPER;

reg		CLK;
reg		RST;
reg		wr_en;
reg		rd_en;
reg	[7:0]	data_in;
wire	[3:0]	wr_adr;
wire	[3:0]	rd_adr;
wire		empty;
wire		full;
wire	[7:0]	data_out;

FIFO #(8,4,8) FIFO0 (
	.CLK(CLK),
	.RST(RST),
	.wr_en(wr_en),
	.rd_en(rd_en),
	.wr_adr(wr_adr),
	.rd_adr(rd_adr),
	.data_in(data_in),
	.empty(empty),
	.full(full),
	.data_out(data_out)
);

initial			CLK <= 1'b0;
always #(CLK_HPER)	CLK <= ~CLK;

initial
begin
	RST <= 1'b1;
	wr_en <= 1'b0;
	rd_en <= 1'b0;
	data_in <= 8'd0;
	#(2*CLK_HPER);
	RST <= 1'b0;
	wr_en <= 1'b1;
	data_in <= 8'd97;
	#(2*CLK_HPER);
	data_in <= 8'd98;
	#(2*CLK_HPER);
	data_in <= 8'd99;
	#(2*CLK_HPER);
	data_in <= 8'd100;
	#(2*CLK_HPER);
	data_in <= 8'd101;
	#(2*CLK_HPER);
	data_in <= 8'd102;
	#(2*CLK_HPER);
	data_in <= 8'd103;
	#(2*CLK_HPER);
	data_in <= 8'd104;
	@(posedge full);
	wr_en <= 1'b0;
	rd_en <= 1'b1;
	#(4*CLK_HPER);
	rd_en <= 1'b0;
	#(2*CLK_HPER);
	rd_en <= 1'b1;
	@(posedge empty);
	wr_en <= 1'b1;
	rd_en <= 1'b0;
end

initial
begin
	$dumpfile("tb.vcd");
	$dumpvars(0,TB);
	#(SIM_TIME);
	$finish();
end

endmodule
