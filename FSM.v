module FSM (clk, reset, flash_mem_read, flash_mem_address, flash_mem_byteenable, flash_mem_waitrequest, flash_mem_readdata, flash_mem_readdatavalid);
    input clk, reset;
    output flash_mem_read, flash_mem_address, flash_mem_byteenable, flash_mem_waitrequest, flash_mem_readdata, flash_mem_readdatavalid;

    reg state;

    always @(posedge clk, negedge reset) begin

    end
endmodule