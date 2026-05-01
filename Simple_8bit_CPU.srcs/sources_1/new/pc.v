`timescale 1ns / 1ps

module pc(
    input        clk,
    input        reset,
    input  [7:0] pc_next,
    output reg [7:0] pc_out
);
    always @(posedge clk or posedge reset) begin
        if (reset)
            pc_out <= 8'b0;
        else
            pc_out <= pc_next;
    end
endmodule