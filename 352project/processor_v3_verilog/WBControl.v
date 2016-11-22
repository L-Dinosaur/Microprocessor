
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