// Branch Control State Machine 


module HazardFSM(
	IR1, 
	IR2, 
	IR3,
	N,Z,
	reset, clock,
	ALU1Sel,
	FlagWrite,
	IR1Sel,
	ALUPC1,
	PCSel,
	data_hazard,
	IR1Load,
	IR2Sel
);

	//FlagWrite has already been handled by EXControl properly 

	input	[7:0] IR1, IR2, IR3; //IR3 wasnt used for handling branch, but might be useful for handling other hazards
	input	N, Z;
	input	reset, clock, data_hazard;
	
	output [1:0] ALU1Sel; 
	output FlagWrite; 
	output IR1Sel, IR2Sel; 
	output [7:0] ALUPC1;
	output PCSel, IR1Load;
	
	
	reg [1:0] ALU1Sel;
	reg FlagWrite; 
	reg IR1Sel, IR1Load, IR2Sel; 
	reg [7:0] ALUPC1;
	reg PCSel;
	
	
	reg [3:0]	state;
	parameter [4:0] c0 = 0, c1_branch = 1, c2_branch = 2, c2_bpz = 3, c2_bnz = 4, c2_bz = 5, c3_branch = 6, reset_s = 7,
					c1_data = 8, c2_data = 9;
	
	
	always @ (posedge clock or posedge reset) 
	begin
		if(reset)
			state = reset_s;
		else
		begin
			case(state) 
				reset_s: state = c0;
				c0:	
				begin
						if (IR1[3:0] == 4'b1101) state = c1_branch; //branch 
						else if (IR1[3:0] == 4'b1001) state = c1_branch; 
						else if (IR1[3:0] == 4'b0101) state = c1_branch; 
						else if (data_hazard == 1) state = c1_data;
						else state = c0;
				end
				c1_branch:	
				begin
						if (IR2[3:0] == 4'b1101)	state = c2_bpz;
						else if (IR2[3:0] == 4'b1001)	state = c2_bnz;
						else if (IR2[3:0] == 4'b0101)	state = c2_bz;
						else state = c0; //default case
				end
				c2_bpz: 	state = c3_branch;
				c2_bnz: 	state = c3_branch;
				c2_bz: 		state = c3_branch;
				c3_branch:	state = c0;
				c1_data:	state = c2_data;
				c2_data:	state = c0;
				default: state = c0;
			endcase
		end
	end
	
	always @(*)
	begin
		case(state)
			reset_s:
			begin
				FlagWrite = 0;
				ALU1Sel = 2'b10;
				ALUPC1 = 0; // freeze PC increment
				IR1Sel = 1; //0 = nop 
				PCSel = 1;
				IR2Sel = 1;
				IR1Load = 1;
			end
			c0:
			begin
				FlagWrite = 1;
				ALU1Sel = 2'b10; // select R1
				PCSel = 1;
				if (IR1[3:0] == 4'b1101 || IR1[3:0] == 4'b1001 || IR1[3:0] == 4'b0101)	
				begin
					ALUPC1 = 0; // freeze PC increment
					IR1Sel = 0; //0 = nop 
					IR2Sel = 1;
					IR1Load = 1;
				end
				else if(data_hazard == 1)
				begin
					ALUPC1 = 0;
					IR1Load = 0;
					IR2Sel = 0;
					IR1Sel = 1;
				end
				else 
				begin
					ALUPC1 = 1; // 1 = increment ALUPC by 1 
					IR1Sel = 1; //1 = normal instruction
					IR1Load = 1;					
					IR2Sel = 1;
				end
			end
			c1_branch:
			begin
				FlagWrite = 1;
				ALUPC1 = 0; //0 = no increment 
				IR1Sel = 0; // 0 = nop
				ALU1Sel = 2'b10; // select R1
				PCSel = 1;
				IR2Sel = 1;
				IR1Load = 1;
			end
			c2_bpz:
			begin
				FlagWrite = 0;
				IR1Sel = 0; //1 corresponds to normal instruction
				ALU1Sel = 2'b01; // select R1
				IR2Sel = 1;
				IR1Load = 1;
				if(!N)
				begin
					PCSel = 0;
					ALUPC1 = 0; //doesnt matter actually for ALUPC at this stage 
				end
				else
				begin
					PCSel = 1;
					ALUPC1 = 1; //this, however, does matter
				end
				
				
			end
			c2_bnz:
			begin
				FlagWrite = 0;
				IR1Sel = 0; //1 corresponds to normal instruction
				ALU1Sel = 2'b01; // select R1
				IR2Sel = 1;
				IR1Load = 1;
				if(!Z)
				begin
					PCSel = 0;
					ALUPC1 = 0; //doesnt matter actually for ALUPC at this stage 
				end
				else
				begin
					PCSel = 1;
					ALUPC1 = 1; //this, however, does matter
				end
				
				
			end
			c2_bz:
			begin
				FlagWrite = 0;
				IR1Sel = 0; //1 corresponds to normal instruction
				ALU1Sel = 2'b01; // select R1
				IR2Sel = 1;
				IR1Load = 1;
				if(Z)
				begin
					PCSel = 0;
					ALUPC1 = 0; //doesnt matter actually for ALUPC at this stage 
				end
				else
				begin
					PCSel = 1;
					ALUPC1 = 1; //this, however, does matter
				end
				
				
			end
			
			c3_branch:
			begin
				//MemRead is always set of on in FetchControl except at reset
				FlagWrite = 1;
				ALU1Sel = 2'b10; // select R1
				IR1Sel = 1;
				ALUPC1 = 1;
				PCSel = 1;
				IR2Sel = 1;
				IR1Load = 1;
			end
			c1_data:
			begin
				FlagWrite = 1;
				ALU1Sel = 2'b10; // select R1
				IR1Sel = 1;
				ALUPC1 = 0;
				PCSel = 1;
				IR2Sel = 0; // 0 = nop
				IR1Load = 0;
			end
			c2_data:
			begin
				FlagWrite = 1;
				ALU1Sel = 2'b10; // select R1
				IR1Sel = 1;
				ALUPC1 = 1;
				PCSel = 1;
				IR2Sel = 1;
				IR1Load = 1;
			end
			default:
			begin
				FlagWrite = 0;
				ALU1Sel = 2'b10;
				ALUPC1 = 0; // freeze PC increment
				IR1Sel = 0; //0 = nop 
				PCSel = 1;
				IR2Sel = 0;
				IR1Load = 0;
			end	
		endcase
	end
endmodule
		
			