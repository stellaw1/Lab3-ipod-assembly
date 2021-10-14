module Address_FSM (clk, Reset, address);
    input clk;
	input Reset;
	output[31:0] address;

	reg [31:0] address = 0;

	always @(posedge clk, negedge Reset) begin
		if (~Reset)
			address <= 0;

		else if (address >= 32'h7FFFF) //TODO what to do when I reach end of file
			address <= 0;

		else
			address <= address + 1'b1;
	end
endmodule