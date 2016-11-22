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

module DecodeControl
(
	clock, reset, IR2Load
);
	input clock, reset;
	output IR2Load;
	reg IR2Load;
	always @(posedge clock or posedge reset)
	begin 
		if (reset)
			IR2Load <= 0;
		else
			IR2Load <= 1; 
		
	end 
endmodule 

module RFControl 
(
	clock, reset, IR3Load, IR2wire_out, R1R2Load, R1Sel
);
	input clock, reset;
	input [3:0] IR2wire_out;
	output R1R2Load, IR3Load, R1Sel;
	reg R1R2Load, IR3Load, R1Sel;
	always @(posedge clock or posedge reset)
	begin
		if(reset)
		begin
			IR3Load <= 0; 
			R1R2Load <= 0;
		end
		else if( IR2wire_out[3:0] == 4'b0111) //ORI
		begin
			IR3Load <= 1;
			R1Sel <= 1;
			R1R2Load <= 1;
		end
		else
		begin
			IR3Load <= 1;
			R1Sel <= 0;
			R1R2Load <= 1;
		end
	end
endmodule

module WBControl
(
	clock, reset, RegIn, RFWrite, IR4Wire_out
)
	//Regin should be 0 for all cases except load 
	input clock, reset;
	input [3:0] IR4Wire_out;
	output  RegIn, RFWrite;
	reg RegIn, RFWrite;
	always @ (posedge clock or posedge reset)
	begin
		if(reset)
		begin
			RFWrite = 0;
			RegIn = 0 ;
		
		end
		if (IR4Wire_out[3:0] == 4'b0000) //load instruction
		begin
			RFWrite = 1;
			RegIn = 1;
		end
		else
		begin
			RFWrite = 1;
			RegIn = 0;
		end
	end
endmodule
	

