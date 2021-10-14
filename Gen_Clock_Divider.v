`timescale 1ns / 1ps
module Gen_Clock_Divider(inclk, outclk, div_clk_count, Reset);
    input inclk;
	input Reset;
	output outclk;
	input[31:0] div_clk_count;

	reg outclk = 0;
	reg [31:0] count = 0;

	always @(posedge inclk, negedge Reset) begin
		if (~Reset) begin
			count <= 32'b0;
			outclk <= 1'b0;
		end

		else if (count >= (div_clk_count - 1)) begin
			count <= 32'b0;
			outclk <= ~outclk;
		end
			
		else
			count <= count + 1'b1;
	end
endmodule