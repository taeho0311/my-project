module TB;

localparam CLK_HPER = 5;
localparam SIM_TIME = 5*20*CLK_HPER;

reg		CLK;
reg		RST;
reg		wr_en;
reg		rd_en;
reg	[7:0]	data_din;
reg	[3:0]	data_cin;
wire		full;
wire		empty;
wire	[7:0]	data_o;
wire		ready;

DECODE_FIFO DECODE (
	.CLK(CLK),
	.RST(RST),
	.wr_en(wr_en),
	.rd_en(rd_en),
	.data_din(data_din),
	.data_cin(data_cin),
	.full(full),
	.empty(empty),
	.data_o(data_o),
	.ready(ready)
);

initial				CLK <= 1'b0;
always #(CLK_HPER)		CLK <= ~CLK;

initial
begin
	RST <= 1'b1;
	wr_en <= 1'b0;
	rd_en <= 1'b0;
	data_din <= 8'd0;
	data_cin <= 4'd0;
	#(2*CLK_HPER);
	RST <= 1'b0;
	#(2*CLK_HPER);
	wr_en <= 1'b1;
	data_din <= 8'd97;
	data_cin <= 4'd3;
	#(2*CLK_HPER);
	data_din <= 8'd98;
	data_cin <= 4'd2;
	#(2*CLK_HPER);
	data_din <= 8'd99;
	data_cin <= 4'd1;
	#(2*CLK_HPER);
	data_din <= 8'd100;
	data_cin <= 4'd2;
	#(2*CLK_HPER);
	data_din <= 8'd101;
	data_cin <= 4'd5;
	#(2*CLK_HPER);
	data_din <= 8'd102;
	data_cin <= 4'd2;
	#(2*CLK_HPER);
	data_din <= 8'd103;
	data_cin <= 4'd3;
	#(2*CLK_HPER);
	data_din <= 8'd104;
	data_cin <= 4'd1;
	@(posedge full);
	wr_en <= 1'b0;
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
