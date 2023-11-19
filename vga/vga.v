module VGA640x480 (
	input			CLK,
	input			RST,
	output			H_SYNC,
	output			V_SYNC,
	output			PIXEL,
	output		[18:0]	P_COUNT
);

localparam H_ST_ACTIVE = 3'b000;
localparam H_ST_FP = 3'b001;
localparam H_ST_PULSE = 3'b010;
localparam H_ST_BP = 3'b011;

localparam V_ST_ACTIVE = 3'b000;
localparam V_ST_FP = 3'b001;
localparam V_ST_PULSE = 3'b010;
localparam V_ST_BP = 3'b011;

wire	H_ACTIVE = (hcnt == 10'd640);
wire	H_FP = (hcnt == 10'd656);
wire	H_PULSE = (hcnt == 10'd752);
wire	H_BP = (hcnt == 10'd800);

wire	V_ACTIVE = (vcnt == 10'd480);
wire	V_FP = (vcnt == 10'd490);
wire	V_PULSE = (vcnt == 10'd492);
wire	V_BP = (vcnt == 10'd525);



always @*
begin
	casex({PIXEL, P_MAX})
		{1'b0, 1'bx}:	next_PCNT <= P_COUNT;
		{1'b1, 1'b0}:	next_PCNT <= P_COUNT + 1'b1;
		{1'b1, 1'b1}:	next_PCNT <= 19'd0;
	endcase
end

always @*
begin
	casex({H_ST, H_ACTIVE, H_FP, H_PULSE, H_BP})
		{H_ST_ACTIVE, 4'b0xxx}:		next_HST <= H_ST_ACTIVE;	
		{H_ST_ACTIVE, 4'b1xxx}:		next_HST <= H_ST_FP;	
		{H_ST_FP, 4'bx0xx}:		next_HST <= H_ST_FP;	
		{H_ST_FP, 4'bx1xx}:		next_HST <= H_ST_PULSE;	
		{H_ST_PULSE, 4'bxx0x}:		next_HST <= H_ST_PULSE;	
		{H_ST_PULSE, 4'bxx1x}:		next_HST <= H_ST_BP;	
		{H_ST_BP, 4'bxxx0}:		next_HST <= H_ST_BP;	
		{H_ST_BP, 4'bxxx1}:		next_HST <= H_ST_ACTIVE;
	endcase
end

assign H_SYNC = (H_ST == H_ST_PULSE)?1'b0:1'b1;
assign V_SYNC = (V_ST == V_ST_PULSE)?1'b0:1'b1;
assign PIXEL = (V_ST == V_ST_ACTIVE)?((H_ST == H_ST_ACTIVE)?1'b1:1'b0):1'b0;
assign P_MAX = ((H_ACTIVE == 1'b1) && (V_ACTIVE == 1'b1));

always @*
begin
	casex({V_ST, V_ACTIVE, V_FP, V_PULSE, V_BP})
		{V_ST_ACTIVE, 4'b0xxx}:	next_VST <= V_ST_ACTIVE;	
		{V_ST_ACTIVE, 4'b1xxx}:	next_VST <= V_ST_FP;	
		{V_ST_FP, 4'bx0xx}:	next_VST <= V_ST_FP;	
		{V_ST_FP, 4'bx1xx}:	next_VST <= V_ST_PULSE;	
		{V_ST_PULSE, 4'bxx0x}:	next_VST <= V_ST_PULSE;	
		{V_ST_PULSE, 4'bxx1x}:	next_VST <= V_ST_BP;	
		{V_ST_BP, 4'bxxx0}:	next_VST <= V_ST_BP;	
		{V_ST_BP, 4'bxxx1}:	next_VST <= V_ST_ACTIVE;	
	endcase
end
always @*
begin
	casex({H_BP, V_BP})
		{1'b0, 1'b0}:	{next_hcnt, next_vcnt}	<= {hcnt + 1'b1, vcnt};
		{1'b1, 1'b0}:	{next_hcnt, next_vcnt}	<= {10'd0, vcnt + 1'b1};
		{1'b0, 1'b1}:	{next_hcnt, next_vcnt}	<= {hcnt + 1'b1, vcnt};	
		{1'b1, 1'b1}:	{next_hcnt, next_vcnt}	<= {10'd0, 10'd0};
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

reg	[2:0]	next_VST;
wire	[2:0]	V_ST;

REG #(3) REG_VST (
	.CLK(CLK),
	.RST(RST),
	.EN(1'b1),
	.D(next_VST),
	.Q(V_ST)
);

reg	[2:0]	next_HST;
wire	[2:0]	H_ST;

REG #(3) REG_HST (
	.CLK(CLK),
	.RST(RST),
	.EN(1'b1),
	.D(next_HST),
	.Q(H_ST)
);

endmodule
