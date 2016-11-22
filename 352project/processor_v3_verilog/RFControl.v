module RFControl 
(
	clock, reset, IR3Load, IR2wire_out, R1R2Load, R1Sel
);
	input clock, reset;
	input [3:0] IR2wire_out;
	output R1R2Load, IR3Load, R1Sel;
	reg R1R2Load, IR3Load, R1Sel;
	always @(*)
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
		else if (IR2wire_out[3:0] == 4'b1111) //nop
		begin
			IR3Load <= 1;
			R1R2Load <= 0;
		end
		else if (IR2wire_out[3:0] == 4'b0001) //stop
		begin
			IR3Load <= 1;
			R1R2Load <= 0;
		end
		else
		begin
			IR3Load <= 1;
			R1Sel <= 0;
			R1R2Load <= 1;
		end
	end
endmodule