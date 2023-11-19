module DECODING #(
	parameter DW0 = 32,
	parameter DW1 = 32,
	parameter DEPTH = 1024,
	parameter AW = 10
)(
	input				CLK,
	input				RST,
	input				CS,
	input				wr_en,
	input		[AW-1:0]	wr_adr,
	input		[DW0-1:0]	wr_din,
	input		[DW1-1:0]	wr_cin,
	output	reg	[DW0-1:0]	rd_out
);

reg	[DW0-1:0]	mem_d[0:DEPTH-1];
reg	[DW1-1:0]	mem_cnt[0:DEPTH-1];

always @(posedge CLK)
begin
	if(CS & wr_en) mem_d[wr_adr] <= wr_din;
	else if(CS & ~wr_en) rd_out <= mem_d[wr_adr];
end

always @(posedge CLK)
begin
	if(CS & wr_en) mem_cnt[wr_adr] <= wr_cin;
	else if(CS & ~wr_en) next_CNT <= mem_cnt[wr_adr];
end

always @*
begin
	casex(CNT)
		4'd0:	 {next_CNT, rd_out, next_wr} <= {mem_cnt[wr_adr + 1'b1] - 1'b1, mem_d[wr_adr + 1'b1] , wr_adr + 1'b1};
		default: {next_CNT, rd_out, next_wr} <= {CNT - 1'b1, mem_d[wr_adr], wr_adr};
	endcase
end

reg	[AW-1:0]	next_wr;

REG #(3) REG_wr (
	.CLK(CLK),
	.RST(RST),
	.EN(1'b1),
	.D(next_wr),
	.Q(wr_adr)
);

reg	[3:0]	next_CNT;
wire	[3:0]	CNT;

REG #(4) REG_CNT0 (
	.CLK(CLK),
	.RST(RST),
	.EN(1'b1),
	.D(next_CNT),
	.Q(CNT)
);


endmodule
