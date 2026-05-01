`timescale 1ns / 1ps


module pc(
    input clk,
    input reset,
    output reg [7:0] pc_out
);
    always @(posedge clk or posedge reset) begin
        if (reset)
            pc_out <= 8'b00;
        else
            pc_out <= pc_out + 1'b1;
    end
endmodule
