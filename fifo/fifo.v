module FIFO #(
	parameter DW = 8,
	parameter AW = 8,
	parameter DEPTH = 8

)(
	input				CLK,
	input				RST,
	input				wr_en,
	input				rd_en,
	input		[DW-1:0]	data_in,
	output		[AW-1:0]	wr_adr,
	output		[AW-1:0]	rd_adr,
	output				empty,
	output				full,
	output	reg	[DW-1:0]	data_out
);

reg	[DW-1:0]	mem_d[0:DEPTH -1];

always @*
begin
	if(RST) next_wr <= 4'd0;
	else if(~RST & wr_en) next_wr <= wr_adr + 1'b1;
	else if(~RST & ~wr_en) next_wr <= wr_adr;
end

always @*
begin
	if(wr_en) mem_d[wr_adr] <= data_in;	
end

always @*
begin
	if(RST) next_rd <= 4'd0;
	else if(~RST & rd_en) next_rd <= rd_adr + 1'b1;
	else if(~RST & ~rd_en) next_rd <= rd_adr;
end

always @*
begin
	if(rd_en) data_out <= mem_d[rd_adr];
end

always @*
begin
	casex({rd_en,empty})
		2'b01:	{next_wr, next_rd} <= {4'd0, 4'd0};
	endcase
end

assign empty = (wr_adr == rd_adr);
assign full = (wr_adr[2:0] == rd_adr[2:0]) & (wr_adr[3] != rd_adr[3]);


reg	[AW-1:0]	next_wr;
reg	[AW-1:0]	next_rd;

REG #(4) REG_wr (
	.CLK(CLK),
	.RST(RST),
	.EN(1'b1),
	.D(next_wr),
	.Q(wr_adr)
);

REG #(4) REG_rd (
	.CLK(CLK),
	.RST(RST),
	.EN(1'b1),
	.D(next_rd),
	.Q(rd_adr)
);

endmodule
