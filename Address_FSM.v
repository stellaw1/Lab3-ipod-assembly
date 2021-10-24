module Address_FSM (clk, reset, forward, play, address);
    input clk, reset, forward, play;
	output [22:0] address;

	reg [22:0] address = 0;

	parameter [22:0] min_address = 0;
	parameter [22:0] max_address = 23'h7FFFF;

	always @(posedge clk, posedge reset) begin
		if (reset) 
			if (forward)
				address <= min_address;
			else
				address <= max_address;
		else if (play) begin
			if (forward)
				if (address >= max_address) address <= min_address; //restart song when end of file is reached
				else address <= address + 1'b1;
			else 
				if (address <= min_address) address <= max_address;
				else address <= address - 1'b1;
		end
	end
endmodule