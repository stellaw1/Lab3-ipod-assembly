module Address_FSM (clk, sync_clk, reset, forward, play, address);
    input clk, sync_clk, reset, forward, play;
	output [22:0] address;

	reg [22:0] address = 0;

	always @(posedge clk, negedge reset) begin
		if (~reset) 
			address <= 0;
		else if (play & sync_clk) begin
			if (forward)
				if (address >= 23'h7FFFF) address <= 0; //restart song when end of file is reached
				else address <= address + 1'b1;
			else 
				if (address <= 0) address <= 23'h7FFFF;
				else address <= address - 1'b1;
		end
	end
endmodule