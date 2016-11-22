module FetchControl
(
 clock, reset, IR1Load, PCWrite, PCSel
);
	input clock;
	input reset;
	output PCWrite, PCSel, IR1Load;
	reg PCWrite, PCSel, IR1Load;
	always @(posedge clock or posedge reset)
	begin 
		if (reset)
		begin
			PCWrite <= 0;
			IR1Load <= 0;
			PCSel <= 0;
		end
		else
		begin
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
	input clock;
	input reset;
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
	clock, reset, IR3Load, IR3Wire_in; 
)
	input clock, reset, IR3Load, R1R2Load;
	input [3:0] IR3Wire_in;
	always @(posedge clock or posedge reset)
	begin
		if(reset)
			
			R1R2Load = 1;
		else if( instr[3:0] == 4'b0011)
		begin
		state = c3_shift;
		end
		else if (instr[3:0] == 4'b0
		
		else
	end
endmodule

