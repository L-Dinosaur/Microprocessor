module EXControl
(
	clock, reset, IR3, IR4Load,
	ALUop, ALU2, Flagwrite,
	MemWrite, ALUOutWrite,
	MDRload, N, Z, 
	SE4wire, MemRead
);
	input clock, reset, N, Z;
	input [7:0]IR3, SE4wire;

	
	output MemRead;
	reg MemRead;
	


	output [2:0]ALUop;
	output [1:0]ALU2;
	output Flagwrite, MemWrite, ALUOutWrite, IR4Load, MDRload;

	
	reg [2:0]ALUop;
	reg [1:0]ALU2;
	reg Flagwrite, MemWrite, ALUOutWrite, IR4Load, MDRload;
	
	

	
	
	always@(*)
	begin
		if(reset)
		begin
			ALUop = 3'b000;
			ALU2 = 2'b00;
			ALUOutWrite = 0;
			Flagwrite = 0;
			MemWrite = 0;
			IR4Load = 0;
			MemRead = 0;
			MDRload = 0;

		end
		else if(IR3[2:0] == 3'b011) // shift
		begin
			ALUop = 3'b100;
			ALU2 = 2'b11;
			ALUOutWrite = 1;
			Flagwrite = 1;
			MemWrite = 0;
			IR4Load = 1;
			MemRead = 0;
			MDRload = 0;

		end
		else if(IR3[2:0] == 3'b111) // ori
		begin
			ALUop = 3'b010;
			ALU2 = 2'b10;
			ALUOutWrite = 1;
			Flagwrite = 1;
			MemWrite = 0;
			IR4Load = 1;
			MemRead = 0;
			MDRload = 0;

		end
		else if(IR3[3:0] == 4'b0100) // add
		begin
			ALUop = 3'b000;
			ALU2 = 2'b00;
			ALUOutWrite = 1;
			Flagwrite = 1;
			MemWrite = 0;
			IR4Load = 1;
			MemRead = 0;
			MDRload = 0;

		end
		else if(IR3[3:0] == 4'b0110) // sub
		begin
			ALUop = 3'b001;
			ALU2 = 2'b00;
			ALUOutWrite = 1;
			Flagwrite = 1;
			MemWrite = 0;
			IR4Load = 1;
			MemRead = 0;
			MDRload = 0;

		end
		else if(IR3[3:0] == 4'b1000) // nand
		begin
			ALUop = 3'b011;
			ALU2 = 2'b00;
			ALUOutWrite = 1;
			Flagwrite = 1;
			MemWrite = 0;
			IR4Load = 1;
			MemRead = 0;
			MDRload = 0;

		end
		else if(IR3[3:0] == 4'b0000) // load
		begin
			MemRead = 1;
			MDRload = 1;
			ALUop = 3'b000; // dont care here
			ALU2 = 2'b00;
			ALUOutWrite = 0;
			Flagwrite = 0;
			MemWrite = 0;
			IR4Load = 1;

		end
		else if(IR3[3:0] == 4'b0010) // store
		begin
			MemRead = 0;
			MDRload = 0;
			ALUop = 3'b000; // dont care here
			ALU2 = 2'b00;
			ALUOutWrite = 0;
			Flagwrite = 0;
			MemWrite = 1;
			IR4Load = 1;
		
		end
		else if(IR3[3:0] == 4'b1010)
		begin
			MemRead = 0;
			MDRload = 0;
			ALUop = 3'b000;
			ALU2 = 2'b00;
			ALUOutWrite = 0;
			Flagwrite = 0;
			MemWrite = 0;
			IR4Load = 0;
	
		end
		
		else if(IR3[3:0] == 4'b0101) //bz
		begin
			MemRead = 0;
			MDRload = 0;
			ALUop = 3'b000;
			ALU2 = 2'b01;
			ALUOutWrite = 0;
			Flagwrite = 0;
			MemWrite = 0;
			IR4Load = 0;	

		end
		
		else if(IR3[3:0] == 4'b1001) //bnz
		begin
			MemRead = 0;
			MDRload = 0;
			ALUop = 3'b000;
			ALU2 = 2'b01;
			ALUOutWrite = 0;
			Flagwrite = 0;
			MemWrite = 0;
			IR4Load = 0;

		end
		else if(IR3[3:0] == 4'b1101) //bpz
		begin
			MemRead = 0;
			MDRload = 0;
			ALUop = 3'b000;
			ALU2 = 2'b01;
			ALUOutWrite = 0;
			Flagwrite = 0;
			MemWrite = 0;
			IR4Load = 0;


		end
	
		else
		begin
			ALUop = 3'b000;
			ALU2 = 2'b00;
			ALUOutWrite = 0;
			Flagwrite = 0;
			MemWrite = 0;
			IR4Load = 0;
			MemRead = 0;
			MDRload = 0;

		end
	end
endmodule

		
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			