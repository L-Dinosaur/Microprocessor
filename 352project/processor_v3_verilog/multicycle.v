// ---------------------------------------------------------------------
// Copyright (c) 2007 by University of Toronto ECE 243 development team 
// ---------------------------------------------------------------------
//
// Major Functions:	a simple processor which operates basic mathematical
//					operations as follow:
//					(1)loading, (2)storing, (3)adding, (4)subtracting,
//					(5)shifting, (6)oring, (7)branch if zero,
//					(8)branch if not zero, (9)branch if positive zero
//					 
// Input(s):		1. KEY0(reset): clear all values from registers,
//									reset flags condition, and reset
//									control FSM
//					2. KEY1(clock): manual clock controls FSM and all
//									synchronous components at every
//									positive clock edge
//
//
// Output(s):		1. HEX Display: display registers value K3 to K1
//									in hexadecimal format
//
//					** For more details, please refer to the document
//					   provided with this implementation
//
// ---------------------------------------------------------------------

module multicycle
(
SW, KEY, HEX0, HEX1, HEX2, HEX3,
HEX4, HEX5, LEDR
);

// ------------------------ PORT declaration ------------------------ //
input	[1:0] KEY;
input [4:0] SW;
output	[6:0] HEX0, HEX1, HEX2, HEX3;
output	[6:0] HEX4, HEX5;
output reg [17:0] LEDR;

// ------------------------- Registers/Wires ------------------------ //
wire	clock, reset;
wire	IR1Load, IR2Load, IR3Load, IR4Load, MDRLoad, MemRead, MemWrite, PCWrite, RegIn, IR1Load_F, IR1Load_H;
wire	ALUOutWrite, FlagWrite, R1R2Load, R1Sel, RFWrite;
wire	[7:0] R2wire, PCwire, R1wire, RFout1wire, RFout2wire, MEMwire_pc;
wire	[7:0] ALU1wire, ALU2wire, ALUwire, ALUOut, MDRwire, MEMwire, ALUPCwire_out;
wire	[7:0] SE4wire, ZE5wire, ZE3wire, RegWire;
wire	[7:0] PCSelwire_out;
wire 	PCSel;
wire 	[1:0] regWB;
wire 	R1WBSel;
//wire 	[7:0] EXPCWire; 
wire 	[7:0] IR1wire_out, IR2wire_out, IR3wire_out, IR4wire_out;
wire	[7:0] reg0, reg1, reg2, reg3;
wire 	[15:0]counter_output;
wire	[7:0] constant;
wire	[2:0] ALUOp; 
wire 	[1:0] ALU2, ALU1;
wire	[1:0] R1_in;
wire	Nwire, Zwire;
reg		N, Z;
wire	EXMemRead, FetchMemRead;
wire FetchPCSel; 
wire EXFlagWrite;
wire [7:0] IR1_in, IR2_in;

wire PC1Write, PC2Write, PC3Write;
wire [7:0] PC1_out, PC2_out, PC3_out;
wire IR1Sel, IR2Sel;
wire [7:0] ALUPC1;
wire HazardFlagWrite;
wire HazardPCSel, data_hazard;




// ------------------------ Input Assignment ------------------------ //
assign	clock = KEY[1];
assign	reset =  ~KEY[0]; // KEY is active high
assign  IR1Load = IR1Load_F & IR1Load_H;

wire 	[2:0]	add_op;
wire [7:0] nop_instruction;

assign MemRead = EXMemRead | FetchMemRead; //1 sensitive
assign FlagWrite = HazardFlagWrite & EXFlagWrite;  //0 sensitive
assign PCSel = FetchPCSel & HazardPCSel; //0 sensitive; 


// ----------------- END DE2 compatible HEX display ----------------- //

/*
// ------------------- DE1 compatible HEX display ------------------- //
chooseHEXs	HEX_display(
	.in0(reg0),.in1(reg1),.in2(reg2),.in3(reg3),
	.out0(HEX0),.out1(HEX1),.select(SW[1:0])
);
// turn other HEX display off
assign HEX2 = 7'b1111111;
assign HEX3 = 7'b1111111;
assign HEX4 = 7'b1111111;
assign HEX5 = 7'b1111111;
assign HEX6 = 7'b1111111;
assign HEX7 = 7'b1111111;
// ----------------- END DE1 compatible HEX display ----------------- //
*/

// FSM		Control(
	// .reset(reset),.clock(clock),.N(N),.Z(Z),.instr(IR[3:0]),
	// .PCwrite(PCWrite),.MemRead(MemRead),.MemWrite(MemWrite),
	// .IRload(IRLoad),.R1Sel(R1Sel),.MDRload(MDRLoad),.R1R2Load(R1R2Load),
	// .ALU1(ALU1),.ALUOutWrite(ALUOutWrite),.RFWrite(RFWrite),.RegIn(RegIn),
	// .FlagWrite(FlagWrite),.ALU2(ALU2),.ALUop(ALUOp)
// );
HazardFSM HazardCon
(
	.IR1(IR1wire_out),
	.IR2(IR2wire_out),
	.IR3(IR3wire_out),
	.N(N),
	.Z(Z),
	.reset(reset),
	.clock(clock),
	.ALU1Sel(ALU1),
	.FlagWrite(HazardFlagWrite), 
	.IR1Sel(IR1Sel),
	.ALUPC1(ALUPC1),
	.PCSel(HazardPCSel),
	.data_hazard(data_hazard),
	.IR1Load(IR1Load_H),
	.IR2Sel(IR2Sel)
);	

FetchControl FetchCon
(
	.clock(clock),
	.reset(reset),
	.IR1Load(IR1Load_F),
	.PCWrite(PCWrite),
	.FetchPCSel(FetchPCSel),
	.MemRead(FetchMemRead),
	.MEMwire_pc(MEMwire_pc[3:0]), 
	.IR1wire_out(IR1wire_out[3:0])
);

DecodeControl DecodeCon(
	.clock(clock),
	.reset(reset),
	.IR2Load(IR2Load)
);

Comparator Comp(
	.instb(IR1wire_out), .instm(IR2wire_out), 
	.instf(IR3wire_out), .res(data_hazard)
);

RFControl RFCon
(
	.clock(clock),
	.reset(reset),
	.IR3Load(IR3Load),
	.IR2wire_out(IR2wire_out[3:0]),
	.R1R2Load(R1R2Load),
	.R1Sel(R1Sel)
);

EXControl EXCon
(
	.clock(clock),
	.reset(reset),
	.IR3(IR3wire_out),
	.IR4Load(IR4Load),
	.ALUop(ALUOp),
	.ALU2(ALU2),
	.Flagwrite(EXFlagWrite),
	.MemWrite(MemWrite),
	.ALUOutWrite(ALUOutWrite), 
	.MemRead(EXMemRead),
	.MDRload(MDRLoad), 
	.N(N),.Z(Z),
	.SE4wire(SE4wire)
);

WBControl WBCon
(
	.clock(clock),
	.reset(reset),
	.RegIn(RegIn),
	.RFWrite(RFWrite),
	.IR4Wire_out(IR4wire_out),
	.R1WBSel(R1WBSel)
);

counter ProgramCounter (
	.reset(reset),
	.clock(clock),
	.instr(IR3wire_out[3:0]), 
	.counter_output(counter_output)

);

// ------------------- DE2 compatible HEX display ------------------- //
HEXs	HEX_display(
	.in0(reg0),.in1(reg1),.in2(reg2),.in3(reg3),.selH(SW[2]),
	.out0(HEX0),.out1(HEX1),.out2(HEX2),.out3(HEX3),
	.out4(HEX4),.out5(HEX5),.counter_output(counter_output)
);

memory	DataMem(
	.MemRead(MemRead),.wren(MemWrite),.clock(clock),
	.address(R2wire),.data(R1wire),.q(MEMwire),
	.address_pc(PCwire),.q_pc(MEMwire_pc)
);

ALU		ALU(
	.in1(ALU1wire),.in2(ALU2wire),.out(ALUwire),
	.ALUOp(ALUOp),.N(Nwire),.Z(Zwire)
);

ALU		ALUPC(
	.in1(PCwire),
	.in2(ALUPC1), // ALUPC1 is from HazardFSM
	.out(ALUPCwire_out),
	.ALUOp(add_op)
	// ,.N(xx),.Z(xx)
);

RF		RF_block(
	.clock(clock),.reset(reset),.RFWrite(RFWrite),
	.dataw(RegWire),.reg1(R1_in),.reg2(IR2wire_out[5:4]),
	.regw(regWB),.data1(RFout1wire),.data2(RFout2wire),
	.r0(reg0),.r1(reg1),.r2(reg2),.r3(reg3)
);

register_8bit	IR1_reg(
	.clock(clock),.aclr(reset),.enable(IR1Load),
	.data(IR1_in),.q(IR1wire_out)
);

register_8bit	IR2_reg(
	.clock(clock),.aclr(reset),.enable(IR2Load),
	.data(IR2_in),.q(IR2wire_out)
);

register_8bit	IR3_reg(
	.clock(clock),.aclr(reset),.enable(IR3Load),
	.data(IR2wire_out),.q(IR3wire_out)
);

register_8bit	IR4_reg(
	.clock(clock),.aclr(reset),.enable(IR4Load),
	.data(IR3wire_out),.q(IR4wire_out)
);

register_8bit	MDR_reg(
	.clock(clock),.aclr(reset),.enable(MDRLoad),
	.data(MEMwire),.q(MDRwire)
);

register_8bit	PC(
	.clock(clock),.aclr(reset),.enable(PCWrite),
	.data(PCSelwire_out),.q(PCwire)
);

//////////////////////////PCs coresponding IR1 IR2 IR3
register_8bit	PC1(
	.clock(clock),.aclr(reset),.enable(PC1Write),
	.data(PCwire),.q(PC1_out)
);

register_8bit	PC2(
	.clock(clock),.aclr(reset),.enable(PC2Write),
	.data(PC1_out),.q(PC2_out)
);

register_8bit	PC3(
	.clock(clock),.aclr(reset),.enable(PC3Write),
	.data(PC2_out),.q(PC3_out)
);
////////////////////////////////////////////////////

register_8bit	R1(
	.clock(clock),.aclr(reset),.enable(R1R2Load),
	.data(RFout1wire),.q(R1wire)
);

register_8bit	R2(
	.clock(clock),.aclr(reset),.enable(R1R2Load),
	.data(RFout2wire),.q(R2wire)
);

register_8bit	ALUOut_reg(
	.clock(clock),.aclr(reset),.enable(ALUOutWrite),
	.data(ALUwire),.q(ALUOut)
);

mux2to1_2bit		R1Sel_mux(
	.data0x(IR2wire_out[7:6]),.data1x(constant[1:0]),
	.sel(R1Sel),.result(R1_in)
);


mux2to1_2bit		R1WBSel_mux(
	.data0x(IR4wire_out[7:6]),.data1x(constant[1:0]),
	.sel(R1WBSel),.result(regWB)
);
/* 
 * Don't need addrsel mux anymore since addr_pc and addr_data
 * go from different wires now
 
mux2to1_8bit 		AddrSel_mux(
	.data0x(R2wire),.data1x(PCwire),
	.sel(AddrSel),.result(AddrWire)
);
*/

mux2to1_8bit		IR2Mux(
	.data0x(nop_instruction), .data1x(IR1wire_out),
	.sel(IR2Sel), .result(IR2_in)
);

mux2to1_8bit 		RegMux(
	.data0x(ALUOut),.data1x(MDRwire),
	.sel(RegIn),.result(RegWire)
);


mux2to1_8bit 		PCSelMux(
	.data0x(ALUwire),.data1x(ALUPCwire_out),
	.sel(PCSel),.result(PCSelwire_out)
);

mux2to1_8bit		IR1Mux(
	.data0x(nop_instruction), .data1x(MEMwire_pc), .sel(IR1Sel), .result(IR1_in)
);

mux5to1_8bit 		ALU1_mux(
	.data0x(constant),.data1x(PC3_out),.data2x(R1wire),.data3x(constant), //data0x, data3x doesnt matter
	.sel(ALU1),.result(ALU1wire)
);

mux5to1_8bit 		ALU2_mux(
	.data0x(R2wire),.data1x(SE4wire),.data2x(ZE5wire),
	.data3x(ZE3wire),.sel(ALU2),.result(ALU2wire)
);

sExtend		SE4(.in(IR3wire_out[7:4]),.out(SE4wire));
zExtend		ZE3(.in(IR3wire_out[5:3]),.out(ZE3wire));
zExtend		ZE5(.in(IR3wire_out[7:3]),.out(ZE5wire));
// define parameter for the data size to be extended
defparam	SE4.n = 4;
defparam	ZE3.n = 3;
defparam	ZE5.n = 5;

always@(posedge clock or posedge reset)
begin
if (reset)
	begin
	N <= 0;
	Z <= 0;
	end
else
if (FlagWrite)
	begin
	N <= Nwire;
	Z <= Zwire;
	end
end




// ------------------------ Assign Constant 1 ----------------------- //
assign	constant = 1;
assign add_op = 3'b000; // for the pc incrementer
assign nop_instruction =  8'b00001010;
assign PC1Write = 1;
assign PC2Write = 1;
assign PC3Write = 1;




// ------------------------- LEDs Indicator ------------------------- //
always @ (*)
begin

    case({SW[4],SW[3]})
    2'b00:
    begin
      LEDR[9] = 0;
      LEDR[8] = 0;
      LEDR[7] = PCWrite;
      //LEDR[6] = AddrSel;
      LEDR[5] = MemRead;
      LEDR[4] = MemWrite;
      LEDR[3] = IR1Load;
      LEDR[2] = R1Sel;
      LEDR[1] = MDRLoad;
      LEDR[0] = R1R2Load;
    end

    2'b01:
    begin
      LEDR[9] = ALU1;
      LEDR[8:7] = ALU2[1:0];
      LEDR[5:3] = ALUOp[2:0];
      LEDR[2] = ALUOutWrite;
      LEDR[1] = RFWrite;
      LEDR[0] = RegIn;
    end

    2'b10:
    begin
      LEDR[9] = 0;
      LEDR[8] = 0;
      LEDR[7] = FlagWrite;
      LEDR[6:2] = constant[7:3];
      LEDR[1] = N;
      LEDR[0] = Z;
    end

    2'b11:
    begin
      LEDR[9:0] = 10'b0;
    end
  endcase
end
endmodule
