module Comparator(instb,instm,instf,res);
	input [7:0]instb, instm, instf;
	output res;
	reg res;
	
	wire [1:0] regb1, regb2, regm, regf;
	wire [2:0] opm, opf, opb;
	
	assign regb1 = instb[7:6];
	assign regb2 = instb[5:4];
	assign regm = instm[7:6];
	assign regf = instf[7:6];
	assign opb = instb[2:0];
	assign opm = instm[2:0];
	assign opf = instf[2:0];
	
	always@(*)
	begin
		if(opb == 3'b111) //ori
		begin
			if((regm == 2'b01) | (regf == 2'b01) | (opm == 3'b111) | (opf == 3'b111))
				res = 1;
			else
				res = 0;
		end
		// k1
		else if((regb1 == 2'b01) | (regb2 == 2'b01))
		begin
			if((opm == 3'b111) | (opf == 3'b111))
				res = 1;
			else if((regm == 2'b01) | (regf == 2'b01))
				res = 1;
			else
				res = 0;
		end
		// k others
		else
		begin
			if((regb1 == regm) | (regb1 == regf) | (regb2 == regm) | (regb2 == regf))
				res = 1;
			else
				res = 0;
		end
	end
endmodule