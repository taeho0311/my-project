module COUNT (
	input			CLK,
	input			RST,
	input		[7:0]	IN,
	output	reg	[7:0]	DATA,
	output	reg	[2:0]	COUNT,
	output	reg	VAILD
);

always @*
begin
	casex(IN)
		prev_IN: {COUNT, DATA, VAILD, next_CNT} <= {3'd0, 8'd0, 1'b0, CNT + 1'b1};
		default: {COUNT, DATA, VAILD, next_CNT} <= {CNT, prev_IN, 1'b1, 3'd1};
	endcase
end


wire	[7:0]	prev_IN;
reg	[2:0]	next_CNT;
wire	[2:0]	CNT;

REG #(8) REG_IN (
	.CLK(CLK),
	.RST(RST),
	.EN(1'b1),
	.D(IN),
	.Q(prev_IN)
);

REG #(3) REG_CNT (
	.CLK(CLK),
	.RST(RST),
	.EN(1'b1),
	.D(next_CNT),
	.Q(CNT)
);

endmodule
