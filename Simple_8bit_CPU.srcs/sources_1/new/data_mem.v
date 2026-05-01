`timescale 1ns / 1ps

module data_mem(
    input        clk,
    input        mem_write,
    input        mem_read,
    input  [7:0] addr,
    input  [7:0] write_data,
    output [7:0] read_data
);
    reg [7:0] ram [255:0];

    assign read_data = (mem_read) ? ram[addr] : 8'b0;

    always @(posedge clk) begin
        if (mem_write)
            ram[addr] <= write_data;
    end
endmodule
