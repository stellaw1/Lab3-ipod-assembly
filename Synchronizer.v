module Synchronizer();
    input async_sig;
    input outclk;
    output out_sync_sig;

    wire q1, q2, q3;

    FDC FDC1(.D(out_sync_sig), .C(~outclk), .CLR(1'b0), .Q(q1));
    FDC FDC2(.D(1'b1), .C(async_sig), .CLR(q1), .Q(q2));
    FDC FDC3(.D(q2), .C(outclk), .CLR(1'b0), .Q(q3));
    FDC FDC4(.D(q3), .C(outclk), .CLR(1'b0), .Q(out_sync_sig));

endmodule

module FDC(D, C, CLR, Q);
    input D;
    input C;
    input CLR;
    output Q;

    always @(posedge C, posedge CLR) begin
        if (CLR)
            Q <= 0;
        else
            Q <= D;
    end

endmodule
