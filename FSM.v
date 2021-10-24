module FSM (clk, reset, play, sync_clk, flash_mem_read, flash_mem_readdatavalid, flash_mem_waitrequest, inc_address, lower, interrupt);
    input clk, reset, play, sync_clk, flash_mem_readdatavalid, flash_mem_waitrequest;

    output flash_mem_read, inc_address, lower, interrupt;

    reg [7:0] state;

    parameter [7:0] INIT =      8'b0000_0000;
    parameter [7:0] INC =       8'b1000_0001;
    parameter [7:0] READ =      8'b0100_0010;
    parameter [7:0] WAIT =      8'b0000_0011;
    parameter [7:0] PLAYL =     8'b0010_0100;
    parameter [7:0] PAUSEL =    8'b0000_0101;
    parameter [7:0] INTL =      8'b0001_0110;
    parameter [7:0] PLAYR =     8'b0000_0111;
    parameter [7:0] PAUSER =    8'b0000_1000;
    parameter [7:0] INTR =      8'b0001_1001;

    always @(posedge clk, posedge reset) begin
        if (reset) state <= INIT;
        else begin
            case (state)
                INIT: if (play) state <= READ;
                    else state <= INIT;
                INC: state <= READ;
                READ: if (~flash_mem_waitrequest) state <= WAIT;
                    else state <= READ;
                WAIT: if (flash_mem_readdatavalid) state <= INTL;
                    else state <= WAIT;
                INTL: state <= PLAYL;
                PLAYL: if (~play) state <= PAUSEL;
                    else if (sync_clk) state <= INTR;
                    else state <= PLAYL;
                PAUSEL: if (play) state <= PLAYR;
                    else state <= PAUSEL;
                INTR: state<= PLAYR;
                PLAYR: if (~play) state <= PAUSER;
                    else if (sync_clk) state <= INC;
                    else state <= PLAYR;
                PAUSER: if (play) state <= INC;
                    else state <= PAUSER;
                default: state <= INIT;
            endcase
        end
    end

    always @(*) begin
        inc_address = state[7];
        flash_mem_read = state[6];
        lower = state[5];
        interrupt = state[4];
    end
endmodule