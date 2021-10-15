module DFF_Enable
#(parameter N = 1)
(   input [N-1:0] D, 
    input clk, reset, enable,
    output [N - 1 : 0] Q);

    always @(posedge clk, posedge reset) begin
        if (reset)
            Q <= 0;
        else if (enable)
            Q <= D;
    end

endmodule