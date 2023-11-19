module REG #(parameter W=1) (
	input			CLK,
	input			RST,
	input			EN,
	input		[W-1:0]	D,
	output	reg	[W-1:0]	Q
);

always @(posedge CLK)
begin
	if(RST)	Q <= 0;
	else if(EN) Q <= D;
end

endmodule
