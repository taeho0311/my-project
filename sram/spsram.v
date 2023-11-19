module SPSRAM #(
	parameter	DW = 32,
	parameter	DEPTH = 1024,
	parameter	AW = 10,
	//초기화 기능
	parameter	INIT_OPTION = 0,
	parameter	INIT_FILE = ""
)(
	input				CLK, 
	input				CS, 
	input				WE, 
	input		[AW-1:0]	A, 
	input		[DW-1:0]	DI,
	output	reg	[DW-1:0]	DO
);

reg	[DW-1:0]	ENTRY [0:DEPTH-1];

always @(posedge CLK)
begin
	if(CS & ~WE)	DO <= ENTRY[A];
end

always @(posedge CLK) 
begin
	if(CS & WE)	ENTRY[A] <= DI;
end

//초기화 binary or hex
initial
begin
	if(INIT_OPTION == 1)
		$readmemb(INIT_FILE, ENTRY);
	else if (INIT_OPTION == 2)
		$readmemh(INIT_FILE, ENTRY);
end


//관찰용 신호 설정
wire	[DW-1:0]	debug0 = ENTRY[0];
wire	[DW-1:0]	debug1 = ENTRY[1];
wire	[DW-1:0]	debug2 = ENTRY[2];
wire	[DW-1:0]	debug3 = ENTRY[3];


endmodule



