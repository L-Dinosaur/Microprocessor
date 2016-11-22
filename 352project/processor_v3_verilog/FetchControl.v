module FetchControl
(
 clock, reset, IR1Load, PCWrite, PCSel, MemRead
);
	input clock, reset;
	output PCWrite, PCSel, IR1Load, MemRead;
	reg PCWrite, PCSel, IR1Load, MemRead;
	always @(posedge clock or posedge reset)
	begin 
		if (reset)
		begin
			MemRead <= 0;
			PCWrite <= 0;
			IR1Load <= 0;
			PCSel <= 0;
		end
		else
		begin
			MemRead <= 1;
			IR1Load <= 1;
			PCSel <= 1;	
			PCWrite <= 1;
		end
	end 
endmodule

//MDR
// IR4Load
//ALUOp...


	

