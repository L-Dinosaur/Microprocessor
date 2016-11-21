
//This submodule counts 

module counter(reset, clock, instr, counter_output);
    input reset, clock;
	input [3:0]instr;
    output [15:0] counter_output;
	reg [15:0] counter_output;
    reg enable; 
	
    parameter stop_op = 4'b0001; 
    parameter max_cycles = 16'b1111111111111111;
	
    always@(posedge clock)
    begin
        if(reset)
        begin
            counter_output = 16'b0; 
            enable = 1;
        end
        
        else if(instr == stop_op)
        begin
            enable = 0;
        end
        
        else if (counter_output == max_cycles)
        begin
            counter_output = 16'b0; 
        end
        
        else if (enable) 
        begin
            counter_output = counter_output + 1;
        end
    end
	
endmodule 

