module VGA640X480 (
	input			CLK,
	input			RST,
	output			H_SYNC,
	output			V_SYNC,
	output			PIXEL,
	output		[18:0]	P_COUNT
);

localparam H_ACTIVE = 639;
localparam H_FP = H_ACTIVE + 16;
localparam H_PULSE = H_FP + 96;
localparam H_BP = H_PULSE + 48;

localparam V_ACTIVE = 479;
localparam V_FP = V_ACTIVE + 10;
localparam V_PULSE = V_FP + 2;
localparam V_BP = V_PULSE + 33;

wire	H_TOTAL = (hcnt == H_BP);
wire	V_TOTAL = (vcnt == V_BP);
wire	P_MAX = (P_COUNT == (H_ACTIVE + 1'b1)*(V_ACTIVE + 1'b1)-1'b1);

assign PIXEL = (hcnt <= H_ACTIVE) && (vcnt <= V_ACTIVE);
assign H_SYNC = ~((hcnt > H_FP) && (hcnt <= H_PULSE));
assign V_SYNC = ~((vcnt > V_FP) && (vcnt <= V_PULSE));

always @*
begin
	casex({H_TOTAL,V_TOTAL})
		{1'b0, 1'b0}:	{next_hcnt, next_vcnt}	<={hcnt+ 1'b1, vcnt};
		{1'b1, 1'b0}:	{next_hcnt, next_vcnt}	<={10'd0, vcnt + 1'b1};
		{1'b0, 1'b1}:	{next_hcnt, next_vcnt}	<={hcnt+ 1'b1, vcnt};
		{1'b1, 1'b1}:	{next_hcnt, next_vcnt}	<={10'd0, 10'd0};
	endcase
end

always @*
begin
	casex({PIXEL, P_MAX})
		{1'b0, 1'b0}:	next_PCNT <= P_COUNT;
		{1'b1, 1'b0}:	next_PCNT <= P_COUNT + 1'b1;
		{1'b0, 1'b1}:	next_PCNT <= P_COUNT;
		{1'b1, 1'b1}:	next_PCNT <= 19'd0;
	endcase
end

reg	[18:0]	next_PCNT;
reg	[9:0]	next_hcnt;
reg	[9:0]	next_vcnt;
wire	[9:0]	hcnt;
wire	[9:0]	vcnt;

REG #(19) REG_P (
	.CLK(CLK),
	.RST(RST),
	.EN(1'b1),
	.D(next_PCNT),
	.Q(P_COUNT)
);

REG #(10) REG_H (
	.CLK(CLK),
	.RST(RST),
	.EN(1'b1),
	.D(next_hcnt),
	.Q(hcnt)
);

REG #(10) REG_V (
	.CLK(CLK),
	.RST(RST),
	.EN(1'b1),
	.D(next_vcnt),
	.Q(vcnt)
);

endmodule
