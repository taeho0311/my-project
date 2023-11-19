module TEXTCOUNT (
	input			CLK,
	input			RST,
	input		[7:0]	IN,
	output	reg	[7:0]	DATA,
	output	reg	[2:0]	COUNT,
	output	reg		VALID
);

localparam ST0 = 2'b00;
localparam ST1 = 2'b01;
localparam ST2 = 2'b10;
localparam ST3 = 2'b11;

reg	[2:0]	next_CNT;
wire	[2:0]	CNT;

always @*
begin
	casex({ST,IN})
		{ST0,8'd97}:	{next_CNT,next_ST,DATA,COUNT,VALID} <= {CNT + 1'b1,ST0,8'd0,3'd0,1'd0};
		{ST0,8'd98}:	{next_CNT,next_ST,DATA,COUNT,VALID} <= {3'd1,ST1,8'd97,CNT,1'd1};
		{ST0,8'd99}:	{next_CNT,next_ST,DATA,COUNT,VALID} <= {3'd1,ST2,8'd97,CNT,1'd1};
		{ST0,8'd100}:	{next_CNT,next_ST,DATA,COUNT,VALID} <= {3'd1,ST3,8'd97,CNT,1'd1};
		{ST1,8'd98}:	{next_CNT,next_ST,DATA,COUNT,VALID} <= {CNT + 1'b1,ST1,8'd0,3'd0,1'd0};
		{ST1,8'd99}:	{next_CNT,next_ST,DATA,COUNT,VALID} <= {3'd1,ST2,8'd98,CNT,1'd1};
		{ST1,8'd100}:	{next_CNT,next_ST,DATA,COUNT,VALID} <= {3'd1,ST3,8'd98,CNT,1'd1};
		{ST1,8'd97}:	{next_CNT,next_ST,DATA,COUNT,VALID} <= {3'd1,ST0,8'd98,CNT,1'd1};
		{ST2,8'd99}:	{next_CNT,next_ST,DATA,COUNT,VALID} <= {CNT + 1'b1,ST2,8'd0,3'd0,1'd0};
		{ST2,8'd100}:	{next_CNT,next_ST,DATA,COUNT,VALID} <= {3'd1,ST3,8'd99,CNT,1'd1};
		{ST2,8'd97}:	{next_CNT,next_ST,DATA,COUNT,VALID} <= {3'd1,ST0,8'd99,CNT,1'd1};
		{ST2,8'd98}:	{next_CNT,next_ST,DATA,COUNT,VALID} <= {3'd1,ST1,8'd99,CNT,1'd1};
		{ST3,8'd100}:	{next_CNT,next_ST,DATA,COUNT,VALID} <= {CNT + 1'b1,ST3,8'd0,3'd0,1'd0};
		{ST3,8'd97}:	{next_CNT,next_ST,DATA,COUNT,VALID} <= {3'd1,ST0,8'd100,CNT,1'd1};
		{ST3,8'd98}:	{next_CNT,next_ST,DATA,COUNT,VALID} <= {3'd1,ST1,8'd100,CNT,1'd1};
		{ST3,8'd99}:	{next_CNT,next_ST,DATA,COUNT,VALID} <= {3'd1,ST2,8'd100,CNT,1'd1};
		default:        {next_CNT,next_ST,DATA,COUNT,VALID} <= {CNT + 1'b1,ST2,8'd0,3'd0,1'd0};
	endcase
end

REG #(3) REG_CNT (
	.CLK(CLK),
	.RST(RST),
	.EN(1'b1),
	.D(next_CNT),
	.Q(CNT)
);

reg	[1:0]	next_ST;
wire	[1:0]	ST;

REG #(2) REG_ST (
	.CLK(CLK),
	.RST(RST),
	.EN(1'b1),
	.D(next_ST),
	.Q(ST)
);


endmodule
