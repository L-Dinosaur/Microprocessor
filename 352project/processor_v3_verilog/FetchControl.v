module FetchControl
(
 clock, reset, IR1Load, PCWrite, FetchPCSel, MemRead, MEMwire_pc, IR1wire_out
);
	input clock, reset;
	input [3:0] MEMwire_pc;
	input [3:0] IR1wire_out;
	output PCWrite, FetchPCSel, IR1Load, MemRead;
	reg PCWrite, FetchPCSel, IR1Load, MemRead;
	always @(posedge clock or posedge reset)
	begin 
		if (reset)
		begin
			MemRead <= 0;
			PCWrite <= 0;
			IR1Load <= 0;
			FetchPCSel <= 0;
		end
		else if (MEMwire_pc[3:0] == 4'b0001)
		begin
			MemRead <= 1;
			IR1Load <= 0;
			PCWrite <= 0;
		end
		else if (IR1wire_out[3:0] == 4'b0001)
		begin
			MemRead <= 1;
			IR1Load <= 0;
			PCWrite <= 0;
		end
		else
		begin
			MemRead <= 1;
			IR1Load <= 1;
			FetchPCSel <= 1;	
			PCWrite <= 1;
		end
	end 
endmodule

//MDR
// IR4Load
//ALUOp...


	

