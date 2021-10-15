module Synchronizer(async_clk, clk, out_sync_clk);
    input async_clk;
    input clk;
    output out_sync_clk;

    wire auto_reset, q1, q2, q3, q4;

    FDC FDC1(.D(1),     .clk(async_clk),    .reset(auto_reset),   .Q(q1));
    FDC FDC2(.D(q1),    .clk(clk),          .reset(0),   .Q(q2));
    FDC FDC3(.D(q2),    .clk(clk),          .reset(0),   .Q(q3));
    FDC FDC4(.D(q3),    .clk(clk),          .reset(0),   .Q(q4));

    assign auto_reset = q3 & ~async_clk;
    assign out_sync_clk = ~q4 & q3;

endmodule

module FDC(D, clk, reset, Q);
    input D, clk, reset;
    output Q;

    reg Q;

    always @(posedge clk, posedge reset) begin
        if (reset)
            Q <= 0;
        else
            Q <= D;
    end

endmodule
