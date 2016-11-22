
module WBControl
(
	clock, reset, RegIn, RFWrite, IR4Wire_out, R1WBSel
);
	//Regin should be 0 for all cases except load 
	input clock, reset;
	input [3:0] IR4Wire_out;
	output  RegIn, RFWrite, R1WBSel;
	reg RegIn, RFWrite, R1WBSel;
	always @ (*)
	begin
		if(reset)
		begin
			RFWrite <= 0;
			RegIn <= 0 ;
			R1WBSel <= 0;
		
		end
		if (IR4Wire_out[3:0] == 4'b0000) //load instruction
		begin
			RFWrite <= 1;
			RegIn <= 1;
			R1WBSel <= 0;
		end
		else if (IR4Wire_out[3:0] == 4'b0010) //store instruction
		begin 
			RFWrite <= 0;
			RegIn <= 1;
			R1WBSel <= 0;
		end
		else if (IR4Wire_out[3:0] == 4'b1010)//nop
		begin
			RFWrite <= 0;
			RegIn <= 1;
			R1WBSel <= 0;
		end
		else if (IR4Wire_out[3:0] == 4'b0111) // ori
		begin
			RFWrite <= 1;
			RegIn <= 0;
			R1WBSel <= 1;
			
		end
		else
		begin
			RFWrite <= 1;
			RegIn <= 0;
			R1WBSel <= 0;
		end
	end
endmodule