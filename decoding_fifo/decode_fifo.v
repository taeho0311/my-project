module DECODE_FIFO (
	input			CLK,
	input			RST,
	input			wr_en,
	input			rd_en,
	input		[7:0]	data_din,
	input		[3:0]	data_cin,
	output			full,
	output			empty,
	output	reg	[7:0]	data_o,
	output			ready
);

//ready �ʱ�ȭ
always @*
begin
	if(wr_en) next_ready <= 1'b0;
	else if(rd_en) next_ready <= 1'b1;
end

//ī��Ʈ �ʱ�ȭ
always @*
begin
	if(full) next_CNT <= 4'd0;
end

//���ڵ�
always @*
begin
	casex({ready, max_CNT})
		2'bx0:	{next_CNT, data_o, next_ready} <= {CNT + 1'b1, d_out, 1'b0}; //ī��Ʈ ���� �� fifo �б� �ߴ�
		2'bx1:	{next_CNT, data_o, next_ready} <= {4'd0, d_out, 1'b1}; //ī��Ʈ�� ������ fifo �б�
	endcase
end

wire	[3:0]	wr_adr;
wire	[3:0]	rd_adr;
wire	[7:0]	d_out;
wire	[3:0]	c_out;

//������ ����
FIFO #(8,4,8) FIFO_D (
	.CLK(CLK),
	.RST(RST),
	.wr_en(wr_en),
	.rd_en(ready),
	.data_in(data_din),
	.wr_adr(wr_adr),
	.rd_adr(rd_adr),
	.empty(empty),
	.full(full),
	.data_out(d_out)
);

//ī��Ʈ ����
FIFO #(4,4,8) FIFO_C (
	.CLK(CLK),
	.RST(RST),
	.wr_en(wr_en),
	.rd_en(ready),
	.data_in(data_cin),
	.wr_adr(wr_adr),
	.rd_adr(rd_adr),
	.empty(empty),
	.full(full),
	.data_out(c_out)
);

reg	[3:0]	next_CNT;
wire	[3:0]	CNT;
wire		max_CNT = (CNT == c_out - 1'b1);

REG #(4) REG_CNT (
	.CLK(CLK),
	.RST(RST),
	.EN(rd_en),
	.D(next_CNT),
	.Q(CNT)
);

reg	next_ready;

REG #(1) REG_READY (
	.CLK(CLK),
	.RST(RST),
	.EN(rd_en),
	.D(next_ready),
	.Q(ready)
);

endmodule
