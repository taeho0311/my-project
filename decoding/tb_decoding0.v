module TB;

localparam CLK_HPER = 5;
localparam SIM_TIME = 2*20*CLK_HPER;

reg		CLK;
reg		RST;
reg	[7:0]	data_din;
reg	[3:0]	data_cin;
wire	[7:0]	rd_out;
wire		ready;

DECODING0 DECO0 (
	.CLK(CLK),
	.RST(RST),
	.data_din(data_din),
	.data_cin(data_cin),
	.rd_out(rd_out),
	.ready(ready)
);

initial			CLK <= 1'b0;
always #(CLK_HPER)	CLK <= ~CLK;

initial
begin
	RST <= 1'b1;
	data_din <= 8'd0;
	data_cin <= 4'd0;
	#(2*CLK_HPER);
	RST <= 1'b0;
		
	data_din <= 8'd100;
	data_cin <= 4'd2;
	@(posedge ready);
	data_din <= 8'd97;
	data_cin <= 4'd3;
	@(posedge ready);
	data_din <= 8'd98;
	data_cin <= 4'd2;
	@(posedge ready);
	data_din <= 8'd99;
	data_cin <= 4'd4;
end

initial
begin
	$dumpfile("tb.vcd");
	$dumpvars(0,TB);
	#(SIM_TIME);
	$finish();
end


endmodule
