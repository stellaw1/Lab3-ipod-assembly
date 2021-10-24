module FSM (clk, reset, play, sync_clk, flash_mem_read, flash_mem_readdatavalid, flash_mem_waitrequest, inc_address, lower, interrupt);
    input clk, reset, play, sync_clk, flash_mem_readdatavalid, flash_mem_waitrequest;

    output flash_mem_read, inc_address, lower, interrupt;

    reg [2:0] state; //TODO ensure glitch free

    parameter [2:0] INIT = 3'b000;
    parameter [2:0] INC = 3'b001;
    parameter [2:0] READ = 3'b011;
    parameter [2:0] WAIT = 3'b010;
    parameter [2:0] PLAYL = 3'b110;
    parameter [2:0] PAUSEL = 3'b100;
    parameter [2:0] PLAYR = 3'b101;
    parameter [2:0] PAUSER = 3'b111;

    always @(posedge clk, posedge reset) begin
        if (reset) state <= INIT;
        else begin
            case (state)
                INIT: if (play) state <= READ;
                    else state <= INIT;
                INC: state <= READ;
                READ: if (~flash_mem_waitrequest) state <= WAIT;
                    else state <= READ;
                WAIT: if (flash_mem_readdatavalid) state <= PLAYL;
                    else state <= WAIT;
                PLAYL: if (~play) state <= PAUSEL;
                    else if (sync_clk) state <= PLAYR;
                    else state <= PLAYL;
                PAUSEL: if (play) state <= PLAYR;
                    else state <= PAUSEL;
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
        inc_address = (state == INC);
        flash_mem_read = (state == READ);
        lower = (state == PLAYL);
        interrupt = (state == PLAYL) | (state == PLAYR);
    end
endmodule