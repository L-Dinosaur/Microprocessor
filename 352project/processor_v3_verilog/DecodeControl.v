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