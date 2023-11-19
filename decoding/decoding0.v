module DECODING0 (
	input			CLK,
	input			RST,
	input		[7:0]	data_din,
	input		[3:0]	data_cin,
	output	reg	[7:0]	rd_out,
	output			ready
);

always @*
begin
	casex({max_CNT, ready})
		2'b00:	{next_CNT, rd_out, next_ready} <= {CNT + 1'b1, prev_IN, 1'b0};
		2'b10:	{next_CNT, rd_out, next_ready} <= {4'd0, data_din, 1'b1};
		2'b01:	{next_CNT, rd_out, next_ready} <= {CNT + 1'b1, prev_IN, 1'b0};
		2'b11:	{next_CNT, rd_out, next_ready} <= {4'd0, 8'd0, 1'b1};
	endcase
end

wire	[7:0]	prev_IN;

REG #(8) REG_DIN (
	.CLK(CLK),
	.RST(RST),
	.EN(1'b1),
	.D(data_din),
	.Q(prev_IN)
);

reg	[3:0]	next_CNT;
wire	[3:0]	CNT;
wire		max_CNT = (CNT == data_cin - 1);

REG #(4) REG_CIN (
	.CLK(CLK),
	.RST(RST),
	.EN(1'b1),
	.D(next_CNT),
	.Q(CNT)
);

reg	next_ready;

REG #(1) REG_READY (
	.CLK(CLK),
	.RST(RST),
	.EN(1'b1),
	.D(next_ready),
	.Q(ready)
);

endmodule
